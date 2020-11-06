import 'dart:io';
import 'dart:math';
import 'package:gensim/gensim.dart';
import 'package:gensim/src/objects/consumable.dart';
import 'package:gensim/src/objects/feature.dart';
import 'package:gensim/src/objects/stat_modifiers.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/sim_point.dart';

import 'objects/goal.dart';

class Simulation {
  int maxCycles;
  bool running;
  List<Actor> actors;
  List<Feature> features;
  List<Consumable> consumables;
  SimPoint size;
  List<SimPoint> points;

  Simulation(int worldSizeX, worldSizeY, int maxCycles, List<Actor> actors,
      List<Feature> features, List<Consumable> consumables) {
    size.x = worldSizeX;
    size.y = worldSizeY;
    for (var x = 0; x < size.x; x++) {
      for (var y = 0; y < size.y; y++) {
        points.add(SimPoint(x, y));
      }
    }
    this.maxCycles = maxCycles;
    this.actors = actors;
    this.features = features;
    this.consumables = consumables;
  }

  void run() {
    var cycleCount = 0;
    while (running) {
      cycleCount++;
      _validateSim(cycleCount);
      _cycle();
      sleep(Duration(milliseconds: 500));
    }
  }

  void _cycle() {
    for (var actor in actors) {
      _tryBirth(actor);
      var currentGoal = _findAction(actor.goals);
      var target = currentGoal.stat.modifiedBy;
      var closestPoint = _findNearest(target, actor.location);
      var newTraits =
          _moveActorTowards(actor, closestPoint, target, currentGoal);
      if (newTraits != null) {
        actor.impregnate(newTraits);
      }
    }
  }

  void _tryBirth(Actor actor) {
    if (actor.pregnant == true) {
      actor.giveBirth(this);
    }
  }

  Set<Trait> _isOnPoint(Actor actor, target, Goal currentGoal) {
    var oldPoint = actor.location;
    if (actor.location == oldPoint) {
      if (target == StatModifiers.Actor) {
        currentGoal.stat.value = currentGoal.stat.value + 1;
        return breed(
            oldPoint.contents
                .firstWhere((element) => element is Actor && element != actor),
            actor);
      } else {
        Consumable consuming = (actor.location.contents
            .firstWhere((element) => element is Consumable));
        currentGoal.stat.value = currentGoal.stat.value + consuming.value;
        actor.location.contents.remove(consuming);
      }
    }
    return null;
  }

  Set<Trait> _moveActorTowards(
      Actor actor, SimPoint newPoint, target, Goal currentGoal) {
    var oldPoint = actor.location;
    if ((actor.location.x == newPoint.x) && (actor.location.y == newPoint.y)) {
      return _isOnPoint(actor, target, currentGoal);
    }
    if (actor.location.x < newPoint.x) {
      actor.location.x++;
    } else if (actor.location.x > newPoint.x) {
      actor.location.x--;
    }
    if (actor.location.y < newPoint.y) {
      actor.location.y++;
    } else if (actor.location.y > newPoint.y) {
      actor.location.y--;
    }
    points.firstWhere((p) => p == oldPoint).contents.remove(actor);
    return null;
  }

  ///Returns the nearest point to the location passed in which contains an object of the target type
  SimPoint _findNearest(StatModifiers target, SimPoint currentLocation) {
    var closestPoint;
    var closestPointDouble = SimPoint(0, 0).distanceTo(size);
    if (target == StatModifiers.Actor) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Actor) {
            // && point.contents.firstWhere((element) => element is Actor) != currentLocation.contents.firstWhere((element) => element is Actor
            if (currentLocation.distanceTo(point) < closestPointDouble) {
              closestPointDouble = currentLocation.distanceTo(point);
              closestPoint = point;
            }
          }
        }
      }
    } else if (target == StatModifiers.Consumable) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Consumable) {
            if (currentLocation.distanceTo(point) < closestPointDouble) {
              closestPointDouble = currentLocation.distanceTo(point);
              closestPoint = point;
            }
          }
        }
      }
    }
    return closestPoint;
  }

  Goal _findAction(Set<Goal> goals) {
    Goal current;
    for (var goal in goals) {
      var highestUnsatisfied = goals.length;
      if ((goal.priority <= highestUnsatisfied) &&
          (goal.trySatisfy() == false)) {
        highestUnsatisfied = goal.priority;
        current = goal;
      }
    }
    return current;
  }

  void stop() {
    running = false;
  }

  void add(Object object) {
    if (object is Actor) {
    } else if (object is Feature) {
    } else if (object is Consumable) {}
  }

  //Called each cycle to make sure sim should be running
  void _validateSim(int cycleCount) {
    if (cycleCount >= maxCycles) {
      stop();
    }
  }

  Set<Trait> _tryMutate(Set<Trait> traits) {
    ///This is a vauge estimate at the liklihood of a random mution occuring.
    if (Random().nextInt(1000) <= 6) {
      ///+1 is neccesary because next int gets random num between 0 and max not inclusive of max
      var trait = traits.elementAt(Random().nextInt(traits.length));
      trait.value = Random().nextInt(trait.maxValue + 1);
      return traits;
    }
    return traits;
  }

  Trait _reasonableFluxuation(Trait trait) {
    var newTraitVal;
    if (Random().nextBool()) {
      newTraitVal = trait.value + (trait.value * (Random().nextDouble() / 10));
      if (newTraitVal > trait.maxValue) {
        newTraitVal = trait.maxValue;
      }
    } else {
      newTraitVal = trait.value - (trait.value * (Random().nextDouble() / 10));
      if (newTraitVal < 0) {
        newTraitVal = 0;
      }
    }
    trait.value = newTraitVal;
    return trait;
  }

  Set<Trait> breed(Actor actor1, Actor actor2) {
    Set<Trait> child1Traits;
    Set<Trait> child2Traits;
    if (actor1.traits.length == actor2.traits.length) {
      var crossoverPoint = Random().nextInt(actor1.traits.length);
      for (var i = 0; i <= actor1.traits.length; i++) {
        if (i <= crossoverPoint) {
          child1Traits.add(_reasonableFluxuation(actor2.traits.elementAt(i)));
          child2Traits.add(_reasonableFluxuation(actor1.traits.elementAt(i)));
        } else {
          child1Traits.add(_reasonableFluxuation(actor1.traits.elementAt(i)));
          child2Traits.add(_reasonableFluxuation(actor2.traits.elementAt(i)));
        }
      }
    } else {
      throw Exception('Actors are not of the same species');
    }
    if (Random().nextBool()) {
      return _tryMutate(child1Traits);
    } else {
      return _tryMutate(child2Traits);
    }
  }
}

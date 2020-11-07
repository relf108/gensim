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
  bool running = true;
  List<Actor> actors;
  List<Feature> features;
  List<Consumable> consumables;
  SimPoint size;
  List<SimPoint> points;
  List<Actor> bornThisCycle = [];

  Simulation(int worldSizeX, worldSizeY, int maxCycles, List<Actor> actors,
      List<Feature> features, List<Consumable> consumables) {
    size = SimPoint(worldSizeX, worldSizeY);
    var tmpPoints = <SimPoint>[];
    for (var x = 0; x < size.x; x++) {
      for (var y = 0; y < size.y; y++) {
        tmpPoints.add(SimPoint(x, y));
      }
    }
    points = tmpPoints;
    this.maxCycles = maxCycles;
    //  this.actors = actors;
    this.features = features;
    this.consumables = <Consumable>[];
    for (var consumable in consumables) {
      add(consumable);
    }
    this.actors = <Actor>[];
    for (var actor in actors) {
      add(actor);
    }
  }

  void run() {
    var cycleCount = 0;
    while (running) {
      cycleCount++;
      _cycle();
      _outputState(cycleCount);
      sleep(Duration(milliseconds: 500));
      _validateSim(cycleCount);
    }
  }

  void _cycle() {
    for (var child in bornThisCycle) {
      actors.add(child);
    }
    bornThisCycle.clear();
    for (var actor in actors) {
      _tryBirth(actor);
      var currentGoal = _findAction(actor.goals);
      if (currentGoal != null) {
        var target = currentGoal.stat.modifiedBy;
        var closestPoint = _findNearest(target, actor.location, actor);
        if (closestPoint != null) {
          var newTraits =
              _moveActorTowards(actor, closestPoint, target, currentGoal);
          if (newTraits != null) {
            actor.impregnate(newTraits);
          }
        }
        // else{
        //   actor.location.contents.firstWhere((element) => element.goal)
        // }
      }
    }
  }

  void _outputState(var cycle) {
    for (var actor in actors) {
      print(
          'Alive: ${actor.alive}, Goals: ${actor.goals}, Pregnant: ${actor.pregnant}, Traits: ${actor.traits}, Location: ${actor.location}');
    }
    print(
        'Features: ${features}, Consumables: ${consumables}, CurrentCycle: ${cycle}');
  }

  void _tryBirth(Actor actor) {
    if (actor.pregnant == true) {
      actor.giveBirth(this);
      actor.pregnant = false;
    }
  }

  Set<Trait> _isOnPoint(Actor actor, target, Goal currentGoal, SimPoint point) {
    if (target == StatModifiers.Actor) {
      currentGoal.stat.value = currentGoal.stat.value + 1;
      return _breed(
          point.contents
              .firstWhere((element) => element is Actor && element != actor),
          actor);
    } else {
      Consumable consuming =
          (point.contents.firstWhere((element) => element is Consumable));
      currentGoal.stat.value = currentGoal.stat.value + consuming.value;
      point.contents.remove(consuming);
    }
    return null;
  }

  Set<Trait> _moveActorTowards(
      Actor actor, SimPoint newPoint, target, Goal currentGoal) {
    if ((actor.location.x == newPoint.x) && (actor.location.y == newPoint.y)) {
      if (newPoint.contents.length > 1 || target == StatModifiers.Consumable) {
        return _isOnPoint(actor, target, currentGoal, newPoint);
      }
    }
    points.firstWhere((p) => p == actor.location).contents.remove(actor);
    if (actor.location.x < newPoint.x) {
      //actor.location.x++;
      actor.location = points.firstWhere((p) =>
          p.x == (actor.location.x.toInt() + 1) &&
          p.y == actor.location.y.toInt());
    } else if (actor.location.x > newPoint.x) {
      //actor.location.x--;
      actor.location = points.firstWhere((p) =>
          p.x == (actor.location.x.toInt() - 1) &&
          p.y == actor.location.y.toInt());
    }
    if (actor.location.y < newPoint.y) {
      //actor.location.y++;
      actor.location = points.firstWhere((p) =>
          p.y == (actor.location.y.toInt() + 1) &&
          p.x == actor.location.x.toInt());
    } else if (actor.location.y > newPoint.y) {
      //actor.location.y--;
      actor.location = points.firstWhere((p) =>
          p.y == (actor.location.y.toInt() - 1) &&
          p.x == actor.location.x.toInt());
    }
    actor.location.contents.add(actor);
    return null;
  }

  ///Returns the nearest point to the location passed in which contains an object of the target type
  SimPoint _findNearest(
      StatModifiers target, SimPoint currentLocation, Actor actor) {
    var closestPoint;
    var closestPointDouble = SimPoint(0, 0).distanceTo(size);
    if (target == StatModifiers.Actor) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Actor) {
            // && point.contents.firstWhere((element) => element is Actor) != currentLocation.contents.firstWhere((element) => element is Actor
            if (currentLocation.distanceTo(point) < closestPointDouble &&
                actor.location != point) {
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
    if (closestPoint == null && target == StatModifiers.Actor) {
      closestPoint = currentLocation;
    }
    return closestPoint;
  }

  Goal _findAction(Set<Goal> goals) {
    Goal current;
    var highestUnsatisfied = goals.length;
    for (var goal in goals) {
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
      actors.add(object);
      var location = Random().nextInt(100);
      points[location].contents.add(object);
      object.location = points[location];
    } else if (object is Feature) {
    } else if (object is Consumable) {
      consumables.add(object);
      var location = Random().nextInt(100);
      points[location].contents.add(object);
    }
  }

  //Called each cycle to make sure sim should be running
  void _validateSim(int cycleCount) {
    if (cycleCount >= maxCycles) {
      running = false;
      print('Sim complete');
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

  Set<Trait> _breed(Actor actor1, Actor actor2) {
    var child1Traits = <Trait>{};
    var child2Traits = <Trait>{};
    if (actor1.traits.length == actor2.traits.length) {
      var crossoverPoint = Random().nextInt(actor1.traits.length);
      for (var i = 0; i < actor1.traits.length; i++) {
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

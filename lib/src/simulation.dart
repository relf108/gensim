import 'dart:math';
import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';
import 'sim_show.dart';

class Simulation {
  int maxCycles;
  bool running = true;
  List<Actor> actors = <Actor>[];
  List<Feature> features = <Feature>[];
  List<Plant> plants = <Plant>[];
  SimPoint size;
  List<SimPoint> points = <SimPoint>[];
  Map<Actor, SimPoint> bornThisCycle = {};
  List<Actor> diedThisCycle = [];
  Map<Statistic, int> statChangeMap = {};

  Simulation(
      {@required int worldSizeX,
      @required int worldSizeY,
      @required int maxCycles,
      @required List<Actor> actors,
      List<Feature> features,
      List<Consumable> consumables,
      Map<Statistic, int> statChangeMap}) {
    size = SimPoint(worldSizeX, worldSizeY);
    for (var x = 0; x < size.x; x++) {
      for (var y = 0; y < size.y; y++) {
        points.add(SimPoint(x, y));
      }
    }
    this.maxCycles = maxCycles;
    for (var feature in features) {
      add(feature);
    }
    for (var consumable in consumables) {
      add(consumable);
    }
    for (var actor in actors) {
      add(actor);
    }
    this.statChangeMap.addAll(statChangeMap);
  }

  void run() {
    var cycleCount = 0;
    while (running) {
      cycleCount++;
      cycleStatchanges(statChangeMap);
      _cycle();
      // _outputState(cycleCount);
      SimShow.printSim(this);
      //sleep(Duration(milliseconds: 500));
      _validateSim(cycleCount);
    }
  }

  void _tryBirth(Actor actor) {
    if (actor.pregnant == true &&
        actor.pregnancyTime >=
            actor.traits
                .firstWhere((e) => e.name == 'Gestation Period')
                .value) {
      actor.pregnant = false;
      actor.statistics
          .firstWhere((element) => element.name == 'pregnant')
          .value = 0;
      actor.goals
          .firstWhere((element) => element.stat.name == 'pregnant')
          .satisfied = false;
      actor.pregnancyTime = 0;
      Actor.giveBirth(actor, this);
    } else if (actor.pregnant == true) {
      actor.pregnancyTime++;
    }
  }

  void _tryKill(Actor actor) {
    if (actor.cyclesLeft <= 0) {
      diedThisCycle.add(actor);
    } else {
      for (var stat in actor.statistics) {
        if (stat.killOwnerValue != null) {
          if (stat.value <= stat.killOwnerValue) {
            actor.location.contents.remove(actor);
            diedThisCycle.add(actor);
          }
        }
      }
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

  void _tryGrow() {
    for (var plant in plants) {
      if (plant.consumed) {
        if (plant.cyclesLeftToRegrow == 0) {
          plant.consumed = false;
          plant.cyclesLeftToRegrow = plant.cyclesToRegrow;
          points
              .firstWhere((element) =>
                  element.x == plant.location.x &&
                  plant.location.y == element.y)
              .contents
              .add(plant);
        } else {
          plant.cyclesLeftToRegrow--;
        }
      }
    }
  }

  //Called each cycle to modify stats passes in
  void cycleStatchanges(Map<Statistic, int> statChangeMap) {
    for (var parentStat in statChangeMap.entries) {
      for (var actor in actors) {
        for (var stat1 in actor.statistics) {
          if (stat1.name == parentStat.key.name) {
            stat1.value = stat1.value + parentStat.value;
          }
        }
      }
    }
  }

  void _cycle() {
    for (var actor in diedThisCycle) {
      actors.remove(actor);
    }
    diedThisCycle.clear();
    for (var child in bornThisCycle.entries) {
      add(child.key, child.value);
    }
    bornThisCycle.clear();

    _tryGrow();
    for (var actor in actors) {
      actor.cyclesLeft--;
      _tryKill(actor);
      _tryBirth(actor);
      var currentGoal = _findAction(actor.goals);
      if (currentGoal != null) {
        var target = currentGoal.stat.modifiedBy;
        var closestPoint = _findNearest(target, actor.location, actor);
        if (closestPoint != null) {
          _moveActorTowards(actor, closestPoint, target, currentGoal);
        }
      }
    }
  }

  Set<Trait> _isOnPoint(Actor actor, target, Goal currentGoal, SimPoint point) {
    switch (target) {
      case StatModifiers.Actor:
        return _breed(
            point.contents.firstWhere((element) =>
                element is Actor &&
                element != actor &&
                element.runtimeType == actor.runtimeType &&
                element.canCarryChild != actor.canCarryChild &&
                element.pregnant == false),
            actor);
        break;
      case StatModifiers.Plant:
        Plant consuming = (point.contents.firstWhere(
            (element) => element is Plant && element.consumed == false));
        var statName = currentGoal.stat.name;
        var statToIncrement =
            actor.statistics.firstWhere((stat) => stat.name == statName);
        statToIncrement.value += consuming.value;
        point.contents.remove(consuming);
        consuming.consumed = true;
        consuming.cyclesLeftToRegrow = consuming.cyclesToRegrow;
        break;
      case StatModifiers.Meat:
        Prey prey = (point.contents.firstWhere((element) => element is Prey));
        Meat consuming = (point.contents
            .firstWhere((element) => element is Prey)
            .preyedUponOutput);
        var statName = currentGoal.stat.name;
        var statToIncrement =
            actor.statistics.firstWhere((stat) => stat.name == statName);
        statToIncrement.value += consuming.value;
        point.contents.remove(prey);
        diedThisCycle.add(prey);
    }
    return null;
  }

  void _moveActorTowards(
      Actor actor, SimPoint newPoint, target, Goal currentGoal) {
    var canBreed = _canBreed(target, newPoint, actor);
    if ((actor.location.x == newPoint.x) &&
        (actor.location.y == newPoint.y) &&
        canBreed) {
      _isOnPoint(actor, target, currentGoal, newPoint);
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

  bool _canBreed(target, SimPoint newPoint, Actor actor) {
    var sameSpecies = false;
    var diffGender = false;
    var canBreed = false;
    if (target == StatModifiers.Actor) {
      var tmp = [];
      tmp.addAll(newPoint.contents);
      tmp.remove(actor);
      for (var partner in tmp) {
        if (partner.runtimeType == actor.runtimeType) {
          sameSpecies = true;
          if (partner.pregnant == false && actor.pregnant == false) {
            if (partner.canCarryChild == true) {
              if (actor.canCarryChild == false) {
                diffGender = true;
              }
            } else if (partner.canCarryChild == false) {
              if (actor.canCarryChild == true) {
                diffGender = true;
              }
            }
          }
        }
        if (sameSpecies && diffGender) {
          canBreed = true;
        }
      }
    } else {
      canBreed = true;
    }
    return canBreed;
  }

  ///Returns the nearest point to the location passed in which contains an object of the target type
  SimPoint _findNearest(
      StatModifiers target, SimPoint currentLocation, Actor actor) {
    var closestPoint;
    var closestPointDouble = SimPoint(0, 0).distanceTo(size);
    var avgHealthOfPeers = 0;
    if (target == StatModifiers.Actor) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Actor && obj.canCarryChild == !(actor.canCarryChild)) {
            if (currentLocation.distanceTo(point) < closestPointDouble &&
                actor.location != point) {
              closestPointDouble = currentLocation.distanceTo(point);
              closestPoint = point;
            }
          }
        }
      }
    } else if (target == StatModifiers.Plant) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Plant && obj.consumed == false) {
            if ((currentLocation.distanceTo(point) < closestPointDouble) &&
                (obj.getLocalAvgHealth(obj.getLocalActors(points), actor) >
                    avgHealthOfPeers)) {
              closestPointDouble = currentLocation.distanceTo(point);
              closestPoint = point;
              avgHealthOfPeers =
                  obj.getLocalAvgHealth(obj.getLocalActors(points), actor);
            }
          }
        }
      }
    } else if (target == StatModifiers.Meat) {
      for (var point in points) {
        for (var obj in point.contents) {
          if (obj is Prey) {
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

  void add(Object object, [SimPoint parentLocation]) {
    if (object is Actor) {
      actors.add(object);
      var location;
      if (parentLocation == null) {
        location = Random().nextInt(size.x * size.y);
      } else {
        for (var i = 0; i < points.length; i++) {
          if (points[i] == parentLocation) {
            location = i;
          }
        }
      }
      points[location].contents.add(object);
      object.location = points[location];
    } else if (object is Feature) {
    } else if (object is Consumable) {
      plants.add(object);
      var location = Random().nextInt(size.x * size.y);
      object.location = points[location];
      points[location].contents.add(object);
    }
  }

  //Called each cycle to make sure sim should be running
  void _validateSim(int cycleCount) {
    if (cycleCount >= maxCycles) {
      running = false;
      print('Sim complete');
    }
    if (actors.isEmpty) {
      running = false;
      print('all specied died out');
    }
  }

  Trait _reasonableFluctuation(Trait trait) {
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

    return Trait(trait.name, newTraitVal, trait.maxValue);
  }

  ///Create a new trait set for a child actor based on it's parents
  Set<Trait> _breed(Actor actor1, Actor actor2) {
    Actor femaleActor;
    if (actor1.canCarryChild) {
      var pregGoal = actor1.goals
          .firstWhere((element) => element.stat.name == 'pregnant')
          .stat;
      pregGoal.value = pregGoal.value + 1;
      actor1.pregnant = true;
      femaleActor = actor1;
    } else {
      var pregGoal = actor2.goals
          .firstWhere((element) => element.stat.name == 'pregnant')
          .stat;
      pregGoal.value = pregGoal.value + 1;
      actor2.pregnant = true;
      femaleActor = actor2;
    }
    var child1Traits = <Trait>{};
    var child2Traits = <Trait>{};
    // && actor1.runtimeType == actor2.runtimeType this needs to be put in place once I can have actors give birth to actors
    //of their own subtype.
    if (actor1.runtimeType == actor2.runtimeType) {
      var crossoverPoint = Random().nextInt(actor1.traits.length);
      for (var i = 0; i < actor1.traits.length; i++) {
        if (i <= crossoverPoint) {
          child1Traits.add(_reasonableFluctuation(actor2.traits.elementAt(i)));
          child2Traits.add(_reasonableFluctuation(actor1.traits.elementAt(i)));
        } else {
          child1Traits.add(_reasonableFluctuation(actor1.traits.elementAt(i)));
          child2Traits.add(_reasonableFluctuation(actor2.traits.elementAt(i)));
        }
      }
    } else {
      throw Exception('Actors are not of the same species');
    }
    if (Random().nextBool()) {
      femaleActor.impregnate(child1Traits);
      return _tryMutate(child1Traits);
    } else {
      femaleActor.impregnate(child2Traits);
      return _tryMutate(child2Traits);
    }
  }
}

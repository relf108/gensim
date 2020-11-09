import 'dart:math';
import 'dart:mirrors';
import 'package:meta/meta.dart';

import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/stat_modifiers.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/sim_point.dart';
import 'package:gensim/src/simulation.dart';

///Extend this class to create your own actors e.g Rabbit or Fox
///
///All actors should have a breed property even if not all members of the species can breed.
class Actor {
  bool alive = true;
  Set<Trait> traits;
  Set<Skill> skills;
  Set<Statistic> statistics;
  Set<Goal> goals;
  SimPoint location;
  bool pregnant = false;
  Set<Trait> embryoTraits;
  int pregnancyTime = 0;
  bool canCarryChild;

  Actor(
      {@required Set<Trait> traits,
      @required Set<Skill> skills,
      @required Set<Statistic> statistics,
      @required Set<Goal> goals,
      @required int breedPriority,
      bool canCarryChild,
      SimPoint location}) {
    this.traits = traits;
    this.skills = skills;
    this.statistics = statistics;
    this.goals = goals;
    if (location != null) {
      this.location = location;
    }
    if (canCarryChild != null) {
      if (canCarryChild == true) {
        var pregnancy = Statistic(
            name: 'pregnant',
            value: 0,
            maxValue: 1,
            modifiedBy: StatModifiers.Actor);
        this.statistics.add(pregnancy);
        var getPregnant = Goal(pregnancy, 0, breedPriority);
        this.goals.add(getPregnant);
      }
      this.canCarryChild = canCarryChild;
    } else if (Random().nextBool()) {
      var pregnancy = Statistic(
          name: 'pregnant',
          value: 0,
          maxValue: 1,
          modifiedBy: StatModifiers.Actor);
      this.statistics.add(pregnancy);
      var getPregnant = Goal(pregnancy, 0, breedPriority);
      this.goals.add(getPregnant);
      this.canCarryChild = true;
    } else {
      this.canCarryChild = false;
    }
  }

  ///spawn a child
  Actor.spawnChild(Actor other, Simulation sim) {
    alive = other.alive;
    traits = other.embryoTraits;
    skills = other.skills;
    canCarryChild = false;
    var newStatistics = <Statistic>{};
    for (var stat in other.statistics) {
      if (stat.name != 'pregnant') {
        newStatistics.add(Statistic.clone(stat));
      }
    }
    statistics = newStatistics;

    var newGoals = <Goal>{};
    for (var goal in other.goals) {
      if (goal.stat.name != 'pregnant') {
        newGoals.add(Goal.clone(goal));
      }
    }
    goals = newGoals;

    if (Random().nextBool()) {
      var pregnancy = Statistic(
          name: 'pregnant',
          value: 0,
          maxValue: 1,
          modifiedBy: StatModifiers.Actor);
      statistics.add(pregnancy);
      var getPregnant = Goal(
          pregnancy,
          0,
          other.goals
              .firstWhere((element) => element.stat.name == 'pregnant')
              .priority);
      goals.add(getPregnant);
      canCarryChild = true;
    }

    location = other.location;
    pregnant = false;
    if (other.location != null) {
      location = other.location;
    }
  }

  ///Give birth to actor of child actor's type
  Actor.giveBirth(Actor other, Simulation sim) {
    var classMirror = reflectClass(other.runtimeType);
    var instance =
        classMirror.newInstance(Symbol('spawnChild'), [other, sim]).reflectee;
    sim.bornThisCycle.putIfAbsent(instance, () => other.location);
  }

  void useSkill({String name}) {
    for (var skill in skills) {
      if (skill.name == name) {
        skill.function(skill.name);
      }
    }
  }

  ///should be null until impregnate method is called.
  void impregnate(Set<Trait> traits) {
    embryoTraits = traits;
    pregnant = true;
  }
}

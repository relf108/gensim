import 'dart:mirrors';

import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/sim_point.dart';
import 'package:gensim/src/simulation.dart';

///Extend this class to create your own actors e.g Rabbit or Fox
class Actor {
  bool alive = true;
  Set<Trait> traits;
  Set<Skill> skills;
  Set<Statistic> statistics;
  Set<Goal> goals;
  SimPoint location;
  bool pregnant = false;
  Set<Trait> embryoTraits;

  Actor(Set<Trait> traits, Set<Skill> skills, Set<Statistic> statistics,
      Set<Goal> goals,
      [SimPoint location]) {
    this.traits = traits;
    this.skills = skills;
    this.statistics = statistics;
    this.goals = goals;
    if (location != null) {
      this.location = location;
    }
  }

  ///spawn a child
  Actor.spawnChild(Actor other, Simulation sim) {
    alive = other.alive;
    traits = other.embryoTraits;
    skills = other.skills;
    var newStatistics = <Statistic>{};
    for (var stat in other.statistics) {
      newStatistics.add(Statistic.clone(stat));
    }
    statistics = newStatistics;
    goals = other.goals;
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

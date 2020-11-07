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

  void giveBirth(Simulation sim) {
    var child = Actor(embryoTraits, skills, statistics, goals, location);
    sim.bornThisCycle.add(child);
  }
}

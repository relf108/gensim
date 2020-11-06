import 'package:gensim/gensim.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/sim_point.dart';

class TestActor extends Actor {
  Trait getTrait({String name}) {
    for (var trait in traits) {
      if (trait.name == name) {
        return trait;
      }
    }
    return null;
  }

  Statistic getStat({String name}) {
    for (var stat in statistics) {
      if (stat.name == name) {
        return stat;
      }
    }
    return null;
  }

  //A Skill could also be directly used from an actor with;
  // actor.skills.lookup(skill1).function('actor skill is being used');
  void useSkill({String name}) {
    for (var skill in skills) {
      if (skill.name == name) {
        skill.function(skill.name);
      }
    }
  }

  TestActor(Set<Trait> traits, Set<Skill> skills, Set<Statistic> statistics,
      Set<Goal> goals, SimPoint location)
      : super(traits, skills, statistics, goals, location);
}

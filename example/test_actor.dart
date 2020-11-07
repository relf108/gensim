import 'package:gensim/gensim.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/objects/skill.dart';

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

  TestActor(Set<Trait> traits, Set<Skill> skills, Set<Statistic> statistics,
      Set<Goal> goals)
      : super(traits, skills, statistics, goals);
}

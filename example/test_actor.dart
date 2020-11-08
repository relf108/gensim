import 'package:gensim/src/extendable_classes/actor.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/simulation.dart';

class TestActor extends Actor {
  TestActor(Set<Trait> traits, Set<Skill> skills, Set<Statistic> statistics,
      Set<Goal> goals)
      : super(traits, skills, statistics, goals);

  TestActor.spawnChild(Actor other, Simulation sim) : super.spawnChild(other, sim);
  
}

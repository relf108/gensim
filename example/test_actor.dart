import 'package:gensim/src/extendable_classes/actor.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/simulation.dart';
import 'package:meta/meta.dart';

class TestActor extends Actor {
  TestActor(
      {@required Set<Trait> traits,
      @required Set<Skill> skills,
      @required Set<Statistic> statistics,
      @required Set<Goal> goals,
      int breedPriority = 1,
      bool canCarryChild})
      : super(
            traits: traits,
            skills: skills,
            statistics: statistics,
            goals: goals,
            breedPriority: breedPriority,
            canCarryChild: canCarryChild);

  TestActor.spawnChild(Actor other, Simulation sim)
      : super.spawnChild(other, sim);
}

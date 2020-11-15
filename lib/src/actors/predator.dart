import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Predator extends Actor {
  Predator({
    @required Set<Trait> traits,
    @required Set<Skill> skills,
    @required Set<Statistic> statistics,
    @required Set<Goal> goals,
    @required int breedPriority,
    bool canCarryChild,
  }) : super(
          traits: traits,
          skills: skills,
          statistics: statistics,
          goals: goals,
          breedPriority: breedPriority,
          canCarryChild: canCarryChild,
        );

  ///Calls the spawnChild on the actor class.
  Predator.spawnChild(Actor other, Simulation sim)
      : super.spawnChild(other, sim);
}

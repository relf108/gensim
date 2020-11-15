import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Fox extends Predator {
  Fox(
      {@required Set<Trait> traits,
      @required Set<Skill> skills,
      @required Set<Statistic> statistics,
      @required Set<Goal> goals,
      int breedPriority = 1,
      bool canCarryChild,
      Consumable preyedUponOutput})
      : super(
          traits: traits,
          skills: skills,
          statistics: statistics,
          goals: goals,
          breedPriority: breedPriority,
          canCarryChild: canCarryChild,
        );

  Fox.spawnChild(Actor other, Simulation sim) : super.spawnChild(other, sim);
}

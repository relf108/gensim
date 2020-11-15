import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Bunny extends Prey {
  Bunny(
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
            preyedUponOutput: preyedUponOutput);

  Bunny.spawnChild(Actor other, Simulation sim) : super.spawnChild(other, sim);
}

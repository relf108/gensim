import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Prey extends Actor {
  Prey({
    @required Set<Trait> traits,
    @required Set<Skill> skills,
    @required Set<Statistic> statistics,
    @required Set<Goal> goals,
    @required Consumable preyedUponOutput,
    @required int breedPriority,
    bool canCarryChild,
  }) : super(
            traits: traits,
            skills: skills,
            statistics: statistics,
            goals: goals,
            breedPriority: breedPriority,
            canCarryChild: canCarryChild) {
    this.preyedUponOutput = preyedUponOutput;
  }

  Prey.spawnChild(Actor other, Simulation sim) : super.spawnChild(other, sim);
}

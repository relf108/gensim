import 'package:gensim/src/extendable_classes/actor.dart';
import 'package:gensim/src/objects/consumable.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:meta/meta.dart';
import '../simulation.dart';

class Prey extends Actor {
  Consumable preyedUponOutput;
  Prey({
    @required Set<Trait> traits,
    @required Set<Skill> skills,
    @required Set<Statistic> statistics,
    @required Set<Goal> goals,
    @required Consumable preyedUponOutput,
    int breedPriority = 1,
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

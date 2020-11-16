import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Fox extends Predator<Fox> {
  @override
  Set<Trait> traits;
  @override
  Set<Skill> skills;
  @override
  Set<Statistic> statistics;
  @override
  Set<Goal> goals;
  @override
  int breedPriority;
  @override
  bool canCarryChild;
  @override
  Consumable preyedUponOutput;

  Fox({
    @required this.traits,
    @required this.skills,
    @required this.statistics,
    @required this.goals,
    this.breedPriority = 1,
    this.canCarryChild,
    this.preyedUponOutput
  });

  Fox.createNewBorn();

  @override
  Fox giveBirth() => Fox.createNewBorn();

}

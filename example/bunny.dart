import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Bunny extends Prey<Bunny> {
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

  Bunny(
      {@required this.traits,
      @required this.skills,
      @required this.statistics,
      @required this.goals,
      this.breedPriority = 1,
      this.canCarryChild,
      this.preyedUponOutput});

  Bunny.createNewBorn();
  
  @override
  Bunny giveBirth() {
    return Bunny.createNewBorn();
  }
}

import 'package:gensim/gensim.dart';
import 'package:gensim/src/objects/organism.dart';

///Dont directly extends this class. Instead extend predator or prey
abstract class Actor<A extends Actor<A>> implements Organism {
  Consumable get preyedUponOutput;
  set preyedUponOutput(Consumable preyedUponOutput);

  Set<Trait> get traits;
  set traits(Set<Trait> traits);

  Set<Skill> get skills;
  set skills(Set<Skill> skills);

  Set<Statistic> get statistics;
  set statistics(Set<Statistic> statistics);

  Set<Goal> get goals;
  set goals(Set<Goal> goals);

  int get breedPriority;
  set breedPriority(int breedPriority);

  bool get canCarryChild;
  set canCarryChild(bool canCarryChild);

  A giveBirth();
}

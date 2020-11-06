import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/stat_modifiers.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/sim_point.dart';
import 'test_actor.dart';

void main() {
  var skill1 = Skill(name: 'Talk', function: (str) => print(str));
  var skillList = <Skill>{skill1};

  var trait1 = Trait('Height', 6, 100);
  var trait2 = Trait('Weight', 80, 300);
  var traitList = <Trait>{trait1, trait2};

  var health = Statistic('health', 100, 100, StatModifiers.Consumable);
  var stats = <Statistic>{health};

  var goal1 = Goal(health, 10, 0);

  var actor = TestActor(traitList, skillList, stats, {goal1}, SimPoint(0,0));

  actor.useSkill(name: 'Talk');
  print(actor.alive);
}

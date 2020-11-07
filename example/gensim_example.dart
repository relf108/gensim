import 'package:gensim/src/objects/consumable.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/stat_modifiers.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/simulation.dart';
import 'test_actor.dart';

void main() {
  var skill1 = Skill(name: 'Talk', function: (str) => print(str));
  var skillList = <Skill>{skill1};

  var trait1 = Trait('Height', 6, 100);
  var trait2 = Trait('Weight', 80, 300);
  var traitList = <Trait>{trait1, trait2};

  var health = Statistic('health', 70, 100, StatModifiers.Consumable);
  var pregnant = Statistic('pregnant', 0, 1, StatModifiers.Actor);
  var stats = <Statistic>{health};

  var goal1 = Goal(health, 10, 0);
  var goal2 = Goal(pregnant, 0, 1);
  var goals = <Goal>{goal1, goal2};

  var actor = TestActor(traitList, skillList, stats, {goal1});
  var hornyActor = TestActor(traitList, skillList, stats, goals);

  var sim = Simulation(10, 10, 100, [actor, hornyActor], [], [Consumable(10), Consumable(20), Consumable(20)]);
  sim.run();
}

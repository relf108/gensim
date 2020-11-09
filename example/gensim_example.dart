import 'dart:collection';

import 'package:gensim/src/built_in_traits/gestation_period.dart';
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

  var height = Trait('Height', 6, 100);
  var weight = Trait('Weight', 80, 300);
  var gestationPeriod = GestationPeriod(cycles: 2, maxValue: 10);

  ///Define a parent statistic and clone this each time you want to create a new instance of it.
  ///Simulation will modify stats based on name so when passing a parent stat into the stat change list,
  ///all child stats are modified.
  var parentHealth = Statistic(
      name: 'health',
      value: 70,
      maxValue: 100,
      modifiedBy: StatModifiers.Consumable,
      killOwnerValue: 0);
  var traitList = <Trait>{
    Trait.clone(height),
    Trait.clone(weight),
    Trait.clone(gestationPeriod)
  };
  var stats = <Statistic>{Statistic.clone(parentHealth)};
  var goalHealth2 = Goal(stats.firstWhere((e) => e.name == 'health'), 10, 0);
  var actor = TestActor(
      traits: traitList,
      skills: skillList,
      statistics: stats,
      goals: {goalHealth2},
      canCarryChild: false);

  /// If a goals StatModifier is set to an Actor it is assumed thia goal is to get pregnant.
  var traitFem = Trait.clone(height);
  var traitFem2 = Trait.clone(weight);

  var traitListFem = <Trait>{traitFem, traitFem2, Trait.clone(gestationPeriod)};
  var health1 = Statistic.clone(parentHealth);
  var goalHealth1 = Goal(health1, 30, 0);
  var goals = <Goal>{goalHealth1};

  var hornyActor = TestActor(
      traits: traitListFem,
      skills: skillList,
      statistics: {health1},
      goals: goals,
      canCarryChild: true);

  var statChangeMap = <Statistic, int>{parentHealth: -2};

  var sim = Simulation(10, 10, 100, [actor, hornyActor], [],
      [Consumable(value: 10, cyclesToRegrow: 5), Consumable(value: 20, cyclesToRegrow: 5), Consumable(value: 20, cyclesToRegrow: 5)], statChangeMap);
  sim.run();
}

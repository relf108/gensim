import 'package:gensim/src/built_in_traits/fear_of_sick_kin.dart';
import 'package:gensim/src/built_in_traits/gestation_period.dart';
import 'package:gensim/src/built_in_traits/lifespan.dart';
import 'package:gensim/src/objects/consumeables/meat.dart';
import 'package:gensim/src/objects/consumeables/plant.dart';
import 'package:gensim/src/objects/goal.dart';
import 'package:gensim/src/objects/skill.dart';
import 'package:gensim/src/objects/stat_modifiers.dart';
import 'package:gensim/src/objects/statistic.dart';
import 'package:gensim/src/objects/trait.dart';
import 'package:gensim/src/simulation.dart';
import 'bunny.dart';
import 'fox.dart';

void main() {
  var skill1 = Skill(name: 'Talk', function: (str) => print(str));
  var skillList = <Skill>{skill1};

  var height = Trait('Height', 6, 100);
  var weight = Trait('Weight', 80, 300);
  var gestationPeriod = GestationPeriod(cycles: 2, maxValue: 10);
  var fearOfSickKin = FearOfSickKin(avoidBelowHealth: 70);
  var lifespan = LifeSpan(cycles: 700, maxCycles: 1000);

  ///Define a parent statistic and clone this each time you want to create a new instance of it.
  ///Simulation will modify stats based on name so when passing a parent stat into the stat change list,
  ///all child stats are modified.
  var parentHealthPrey = Statistic(
      name: 'health',
      value: 70,
      maxValue: 100,
      modifiedBy: StatModifiers.Plant,
      killOwnerValue: 0);

  var parentHealthPredator = Statistic(
      name: 'fox health',
      value: 100,
      maxValue: 100,
      modifiedBy: StatModifiers.Meat,
      killOwnerValue: 0);

  var traitList = <Trait>{
    Trait.clone(height),
    Trait.clone(weight),
    Trait.clone(gestationPeriod),
    Trait.clone(fearOfSickKin),
    Trait.clone(lifespan)
  };
  var stats = <Statistic>{
    Statistic.clone(parentHealthPrey),
    Statistic.clone(parentHealthPredator)
  };
  var goalHealth2 = Goal(stats.firstWhere((e) => e.name == 'health'), 30, 0);
  var actor = Bunny(
      traits: traitList,
      skills: skillList,
      statistics: {stats.firstWhere((e) => e.name == 'health')},
      goals: {goalHealth2},
      canCarryChild: false,
      preyedUponOutput: Meat(value: 20));

  /// If a goals StatModifier is set to an Actor it is assumed thia goal is to get pregnant.
  var traitFem = Trait.clone(height);
  var traitFem2 = Trait.clone(weight);

  var traitListFem = <Trait>{
    traitFem,
    traitFem2,
    Trait.clone(gestationPeriod),
    Trait.clone(fearOfSickKin),
    Trait.clone(lifespan)
  };
  var health1 = Statistic.clone(parentHealthPrey);
  var goalHealth1 = Goal(health1, 30, 0);
  var goals = <Goal>{goalHealth1};

  var hornyActor = Bunny(
      traits: traitListFem,
      skills: skillList,
      statistics: {health1},
      goals: goals,
      canCarryChild: true,
      preyedUponOutput: Meat(value: 20));

  var foxHealthGoal =
      Goal(stats.firstWhere((e) => e.name == 'fox health'), 20, 0);

  var fox = Fox(
    goals: {foxHealthGoal},
    skills: {},
    statistics: {Statistic.clone(parentHealthPredator)},
    traits: traitList,
  );

  var statChangeMap = <Statistic, int>{
    parentHealthPrey: -2,
    parentHealthPredator: -1
  };

  var sim = Simulation(
      10,
      10,
      10000,
      [actor, hornyActor],
      [],
      [
        Plant(value: 10, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
        Plant(value: 20, cyclesToRegrow: 10),
      ],
      statChangeMap);
  sim.run();
}

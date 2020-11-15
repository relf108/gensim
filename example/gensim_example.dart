import 'package:gensim/gensim.dart';
import 'bunny.dart';
import 'fox.dart';

void main() {
  ///Skills allow you to make an actor perform a funtion
  var skill1 = Skill(name: 'Talk', function: (str) => print(str));
  var skillList = <Skill>{skill1};

  ///Traits are the features of an actor which evolve as they breed
  var parentTraitHeight = Trait('Height', 6, 100);
  var parentTraitWeight = Trait('Weight', 80, 300);

  ///These are built in traits and need to be set for every actor
  var parentTraitGestationPeriod = GestationPeriod(cycles: 2, maxValue: 10);
  var parentTraitFearOfSickKin = FearOfSickKin(avoidBelowHealth: 70);
  var parentTraitLifespan = LifeSpan(cycles: 200, maxCycles: 500);

  ///Create a list of traits for be given to any actor.
  ///These traits always need be cloned from a parent trait so that a trait changing on one actor
  ///does not change the trait for every actor with that trait.
  var traitListMaleActor = <Trait>{
    Trait.clone(parentTraitHeight),
    Trait.clone(parentTraitWeight),
    Trait.clone(parentTraitGestationPeriod),
    Trait.clone(parentTraitFearOfSickKin),
    Trait.clone(parentTraitLifespan)
  };

  var traitListFemaleActor = <Trait>{
    Trait.clone(parentTraitHeight),
    Trait.clone(parentTraitWeight),
    Trait.clone(parentTraitGestationPeriod),
    Trait.clone(parentTraitFearOfSickKin),
    Trait.clone(parentTraitLifespan)
  };

  ///Define a parent statistic and clone this each time you want to create a new instance of it.
  ///Simulation will modify stats based on name so when passing a parent stat into the stat change list,
  ///all child stats are modified.
  var parentHealthPrey = Statistic(
      name: 'prey health',
      value: 70,
      maxValue: 100,
      modifiedBy: StatModifiers.Plant,
      killOwnerValue: 0);

  var parentHealthPredator = Statistic(
      name: 'predator health',
      value: 100,
      maxValue: 100,
      modifiedBy: StatModifiers.Meat,
      killOwnerValue: 0);

  var statsPrey = <Statistic>{parentHealthPrey};

  var maleHealth = Statistic.clone(statsPrey.first);
  var goalMaleStayAlive = Goal(maleHealth, 30, 0);

  ///This actor cannot carry a child so he is set to male.
  ///That being said he still has female specific traits
  ///which may be passed down to a daughter.
  var maleActor = Bunny(
      traits: traitListMaleActor,
      skills: skillList,
      statistics: {maleHealth},
      goals: {goalMaleStayAlive},
      canCarryChild: false,
      preyedUponOutput: Meat(value: 20));

  ///Clone the prey health statistic and assign that clone to a goal.
  var femaleHealth = Statistic.clone(statsPrey.first);
  var goalFemaleStayAlive = Goal(femaleHealth, 30, 0);

  ///Make certain the same stat instance is passed into
  ///a goal which should be tracking it.
  var femaleActor = Bunny(
      traits: traitListFemaleActor,
      skills: skillList,
      statistics: {femaleHealth},
      goals: {goalFemaleStayAlive},
      canCarryChild: true,
      preyedUponOutput: Meat(value: 20));

  ///Given there is only one fox we can use the parent stats and goals for predators.
  var fox = Fox(
    goals: {Goal(parentHealthPredator, 20, 0)},
    skills: {},
    statistics: {parentHealthPredator},
    traits: traitListMaleActor,
  );

  ///Tell the simulation to add a value to its correlated stat each cycle.
  ///This could be used to simulate hunger etc.
  var statChangeMap = <Statistic, int>{
    parentHealthPrey: -2,
    parentHealthPredator: -1
  };

  ///The simulation is where everything comes together.
  ///It takes and X and Y values which define the size of the sim world (x, y).
  ///maxCycles defines the number cyles to perform before the simulation stops.
  ///actors are the actor objects we defined above (The fun part).
  ///consumables are a list of Consumable objects for the herbivores to eat.
  var sim = Simulation(
      worldSizeX: 10,
      worldSizeY: 10,
      maxCycles: 10000,
      actors: [maleActor, femaleActor, fox],
      consumables: [
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
      statChangeMap: statChangeMap);

  ///Start the simulation and enjoy.
  sim.run();
}

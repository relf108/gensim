import 'dart:math';
import 'package:gensim/gensim.dart';
import 'package:gensim/src/objects/thing.dart';

import 'actor.dart';

///All actors should have a breed property even if not all members of the species can breed.
class ActorImpl implements Thing {
  bool alive = true;
  int cyclesLeft;

  Actor actor;
  SimPoint location;
  bool pregnant = false;
  Set<Trait> embryoTraits;
  int pregnancyTime = 0;

  ///You shouldn't use this class directly. Instead extend it or the predator/prey classes.
  ActorImpl({
    this.actor,
    SimPoint location,
  }) {
    if (location != null) {
      this.location = location;
    }
    if (actor.canCarryChild != null) {
      if (actor.canCarryChild == true) {
        var pregnancy = Statistic(
            name: 'pregnant',
            value: 0,
            maxValue: 1,
            modifiedBy: StatModifiers.Actor);
        actor.statistics.add(pregnancy);
        var getPregnant = Goal(pregnancy, 0, actor.breedPriority);
        actor.goals.add(getPregnant);
      } else if (actor.canCarryChild == false) {
        var inseminated = Statistic(
            name: 'inseminated',
            value: 0,
            maxValue: 1,
            modifiedBy: StatModifiers.Actor);
        actor.statistics.add(inseminated);
        var getPregnant = Goal(inseminated, 0, actor.breedPriority);
        actor.goals.add(getPregnant);
      }
    } else if (Random().nextBool()) {
      var pregnancy = Statistic(
          name: 'pregnant',
          value: 0,
          maxValue: 1,
          modifiedBy: StatModifiers.Actor);
      actor.statistics.add(pregnancy);
      var getPregnant = Goal(pregnancy, 0, actor.breedPriority);
      actor.goals.add(getPregnant);
      actor.canCarryChild = true;
    } else {
      actor.canCarryChild = false;
    }
    cyclesLeft = actor.traits
        .firstWhere((element) => element.name == 'lifespan')
        .value
        .toInt();
  }

  ///Spawn a child dont use this constructor. instead use the giveBirth constructor
  ActorImpl.giveBirth(ActorImpl other, Simulation sim, Actor child) {
    actor = child;

    ///Non gender specific traits.
    alive = other.alive;
    actor.breedPriority = other.actor.breedPriority;
    actor.preyedUponOutput = other.actor.preyedUponOutput;
    actor.traits = other.embryoTraits;
    actor.skills = other.actor.skills;
    actor.canCarryChild = false;
    var newStatistics = <Statistic>{};
    for (var stat in other.actor.statistics) {
      if (stat.name != 'pregnant') {
        newStatistics.add(Statistic.clone(stat));
      }
    }
    actor.statistics = newStatistics;

    var newGoals = <Goal>{};
    for (var goal in other.actor.goals) {
      if (goal.stat.name != 'pregnant' && goal.stat.name != 'inseminated') {
        if (goal.stat.name.contains('health')) {
          newGoals.add(Goal.clone(goal,
              overrideStat: actor.statistics.firstWhere(
                  (element) => element.name.toString().contains('health'))));
        } else {
          newGoals.add(Goal.clone(goal));
        }
      }
    }
    actor.goals = newGoals;

    ///If child is a female
    if (Random().nextBool()) {
      var pregnancy = Statistic(
          name: 'pregnant',
          value: 0,
          maxValue: 1,
          modifiedBy: StatModifiers.Actor);
      actor.statistics.add(pregnancy);
      var getPregnant = Goal(
          pregnancy,
          0,
          other.actor.goals
              .firstWhere((element) => element.stat.name == 'pregnant')
              .priority);
      getPregnant.satisfied = false;
      actor.goals.add(getPregnant);
      actor.canCarryChild = true;
    }

    ///If the child is male
    else {
      var inseminated = Statistic(
          name: 'inseminated',
          value: 0,
          maxValue: 1,
          modifiedBy: StatModifiers.Actor);
      actor.statistics.add(inseminated);
      var impregnate = Goal(
          inseminated,
          0,
          other.actor.goals
              .firstWhere((element) => element.stat.name == 'pregnant')
              .priority);
      actor.goals.add(impregnate);
    }

    ///Non gender specific traits
    location = other.location;
    pregnant = false;
    if (other.location != null) {
      location = other.location;
    }
    cyclesLeft = actor.traits
        .firstWhere((element) => element.name == 'lifespan')
        .value
        .toInt();
    sim.bornThisCycle.putIfAbsent(this, () => other.location);
  }

  ///Use a skill assigned to this actor.
  void useSkill({String name}) {
    for (var skill in actor.skills) {
      if (skill.name == name) {
        skill.function(skill.name);
      }
    }
  }

  ///impregnate this actors with an embryo of the given traits.
  void impregnate(Set<Trait> traits) {
    embryoTraits = traits;
  }
}

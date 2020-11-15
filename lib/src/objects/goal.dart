import 'package:gensim/gensim.dart';

class Goal {
  Statistic stat;
  int priority;
  bool satisfied = false;
  int percentileToSatisfy;

  Goal(Statistic stat, int percentileToSatisfy, int priority) {
    this.stat = stat;
    this.percentileToSatisfy = percentileToSatisfy;
    this.priority = priority;
  }

  Goal.clone(Goal other, {Statistic overrideStat}) {
    if (overrideStat != null) {
      stat = overrideStat;
    } else {
      stat = Statistic(
          name: other.stat.name,
          value: other.stat.value,
          maxValue: other.stat.maxValue,
          modifiedBy: other.stat.modifiedBy);
    }
    priority = other.priority;
    satisfied = other.satisfied;
    percentileToSatisfy = other.percentileToSatisfy;
  }

  bool trySatisfy() {
    if (stat.value >=
        stat.maxValue - (stat.maxValue * (percentileToSatisfy / 100))) {
      satisfied = true;
    } else {
      satisfied = false;
    }
    return satisfied;
  }
}

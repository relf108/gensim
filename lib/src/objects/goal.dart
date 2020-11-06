import 'package:gensim/src/objects/statistic.dart';

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

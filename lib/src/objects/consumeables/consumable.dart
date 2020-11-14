import 'package:gensim/src/actors/actor.dart';
import 'package:gensim/src/built_in_traits/fear_of_sick_kin.dart';
import 'package:gensim/src/sim_point.dart';
import 'package:meta/meta.dart';

class Consumable {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  SimPoint location;
  Consumable({@required var value}) {
    this.value = value;
  }

  List<SimPoint> getPointsToCheck(
      List<SimPoint> points, int radius, int maxX, int maxY) {
    var result = <SimPoint>[];
    var xVals = <int>[];
    var yVals = <int>[];
    for (var i = 0; i < radius; i++) {
      if (location.x + i < maxX && location.x - i >= 0) {
        xVals.add(location.x + i);
        xVals.add(location.x - i);
      }
    }
    for (var i = 0; i < radius; i++) {
      if (location.y + i < maxY && location.y - i >= 0) {
        yVals.add(location.y + i);
        yVals.add(location.y - i);
      }
    }
    for (var x in xVals) {
      for (var y in yVals) {
        result.add(
            points.firstWhere((element) => element.x == x && element.y == y));
      }
    }
    return result;
  }

//TODO untested
  List<Actor> getLocalActors(List<SimPoint> points) {
    var result = <Actor>[];
    var pointsInRadius = getPointsToCheck(points, 2, 10, 10);
    for (var point in pointsInRadius) {
      for (var obj in point.contents) {
        if (obj is Actor) {
          result.add(obj);
        }
      }
    }
    return result;
  }

  int getLocalAvgHealth(List<Actor> localActors, Actor current) {
    var tmpMe;
    for (var me in localActors) {
      if (me == current) {
        tmpMe = me;
      }
    }
    if (tmpMe != null) {
      localActors.remove(tmpMe);
    }
    var overallHealth = 0;
    var i = 0;
    while (i < localActors.length) {
      overallHealth += localActors[i]
          .statistics
          .firstWhere((element) => element.name == 'health')
          .value;
      i++;
    }
    //returns the result of divide as a rounded int
    if (i > 0) {
      return overallHealth ~/ i;
    } else {
      return current.traits
          .firstWhere((element) => element.name == 'fear of sick kin')
          .value
          .toInt();
    }
  }
}

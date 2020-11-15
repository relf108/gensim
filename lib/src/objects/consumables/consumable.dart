import 'package:gensim/gensim.dart';
import 'package:gensim/src/actors/actor_impl.dart';
import 'package:gensim/src/objects/organism.dart';
import 'package:meta/meta.dart';

class Consumable implements Organism {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  SimPoint location;
  Consumable({@required var value}) {
    this.value = value;
  }

  List<SimPoint> _getPointsToCheck(
      List<SimPoint> points, int radius, int maxX, int maxY) {
    var result = <SimPoint>[];
    var xVals = <int>[];
    var yVals = <int>[];
    for (var i = 0; i < radius; i++) {
      if (location.x + i < maxX) {
        xVals.add(location.x + i);
      }
      if (location.x - i >= 0) {
        xVals.add(location.x - i);
      }
    }
    for (var i = 0; i < radius; i++) {
      if (location.y + i < maxY) {
        yVals.add(location.y + i);
      }
      if (location.y - i >= 0) {
        yVals.add(location.y - i);
      }
    }
    for (var x in xVals) {
      for (var y in yVals) {
        var point =
            points.firstWhere((element) => element.x == x && element.y == y);
        if (!result.contains(point)) {
          result.add(point);
        }
      }
    }
    return result;
  }

  ///Returns a list of actors surrounding this object
  List<ActorImpl> getLocalActors(List<SimPoint> points) {
    var result = <ActorImpl>[];
    var pointsInRadius = _getPointsToCheck(points, 4, 10, 10);
    for (var point in pointsInRadius) {
      for (var obj in point.contents) {
        if (obj is ActorImpl) {
          result.add(obj);
        }
      }
    }
    return result;
  }

  ///Returns the local health average of actors around this object
  int getLocalAvgHealth(List<ActorImpl> localActors, ActorImpl current) {
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
          .actor
          .statistics
          .firstWhere((element) => element.name.toString().contains('health'))
          .value;
      i++;
    }
    //returns the result of divide as a rounded int
    if (i > 0) {
      return overallHealth ~/ i;
    } else {
      return current.actor.traits
          .firstWhere((element) => element.name == 'fear of sick kin')
          .value
          .toInt();
    }
  }
}

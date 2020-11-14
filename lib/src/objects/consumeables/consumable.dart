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

  List<Actor> getLocalActors(List<SimPoint> points) {
    var result = <Actor>[];
    for (var surrounding in points) {
      if (surrounding.x == location.x && surrounding.y == location.y) {
        for (var obj in surrounding.contents) {
          if (obj is Actor) {
            result.add(obj);
          }
        }
      }
      if ((surrounding.x == location.x + 1 &&
              surrounding.y == location.y + 1) ||
          (surrounding.x == location.x - 1 &&
              surrounding.y == location.y - 1) ||
          (surrounding.x == location.x + 1 &&
              surrounding.y == location.y - 1) ||
          (surrounding.x == location.x - 1 &&
              surrounding.y == location.y + 1) ||
          (surrounding.x == location.x && surrounding.y == location.y + 1) ||
          (surrounding.x == location.x + 1 && surrounding.y == location.y) ||
          (surrounding.x == location.x && surrounding.y == location.y - 1) ||
          (surrounding.x == location.x && surrounding.y == location.y + 1)) {
        for (var obj in surrounding.contents) {
          if (obj is Actor) {
            result.add(obj);
          }
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
          .value.toInt();
    }
  }
}

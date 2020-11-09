import 'package:gensim/src/extendable_classes/actor.dart';
import 'package:gensim/src/sim_point.dart';
import 'package:meta/meta.dart';

class Consumable {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  bool consumed = false;
  int cyclesToRegrow;
  int cyclesLeftToRegrow;
  SimPoint location;
  Actor fleshOf;

  Consumable({@required var value, var cyclesToRegrow, Actor fleshOf}) {
    this.value = value;
    if (cyclesToRegrow != null) {
      this.cyclesToRegrow = cyclesToRegrow;
      cyclesLeftToRegrow = cyclesToRegrow;
    }
    if (fleshOf != null) {
      this.fleshOf = fleshOf;
    }
  }
}

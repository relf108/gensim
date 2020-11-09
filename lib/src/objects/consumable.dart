import 'package:gensim/src/sim_point.dart';
import 'package:meta/meta.dart';

class Consumable {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  bool consumed = false;
  int cyclesToRegrow;
  int cyclesLeftToRegrow;
  SimPoint location;

  Consumable({@required var value, var cyclesToRegrow}) {
    this.value = value;
    if (cyclesToRegrow != null) {
      this.cyclesToRegrow = cyclesToRegrow;
      cyclesLeftToRegrow = cyclesToRegrow;
    }
  }
}

import 'package:gensim/src/sim_point.dart';
import 'package:meta/meta.dart';

class Consumable {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  SimPoint location;
  Consumable({@required var value}) {
    this.value = value;
  }
}

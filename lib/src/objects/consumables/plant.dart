import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class Plant extends Consumable {
  bool consumed = false;
  int cyclesToRegrow;
  int cyclesLeftToRegrow;
  Plant({@required int value, @required int cyclesToRegrow})
      : super(value: value) {
    if (cyclesToRegrow != null) {
      this.cyclesToRegrow = cyclesToRegrow;
      cyclesLeftToRegrow = cyclesToRegrow;
    }
  }
}

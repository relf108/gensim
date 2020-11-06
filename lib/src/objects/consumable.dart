import 'dart:async';

class Consumable {
  ///an integer representing the positive or negative effect or consuming this object
  int value;
  Timer lifeSpan;

  int onConsumed() {
    return value;
  }
}

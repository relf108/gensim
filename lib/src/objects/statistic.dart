import 'package:gensim/src/objects/stat_modifiers.dart';

///Statistics are non genetic traits.
///Statistics of an actor can change during its lifetime
class Statistic {
  var name;
  var value;
  var maxValue;
  var modifiedBy;

  Statistic(var name, var value, var maxValue, StatModifiers modifiedBy) {
    this.name = name;
    this.value = value;
    this.maxValue = maxValue;
    this.modifiedBy = modifiedBy;
  }

  Statistic.clone(Statistic other) {
    name = other.name;
    value = other.value;
    maxValue = other.maxValue;
    modifiedBy = other.modifiedBy;
  }

  void decrease(int amount) {
    value = value - amount;
  }

  void increase(int amount) {
    value = value + amount;
  }

  void increment() {
    value++;
  }

  void decrement() {
    value--;
  }
}

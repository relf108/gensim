import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

///Statistics are non genetic traits.
///Statistics of an actor can change during its lifetime
class Statistic {
  var name;
  var value;
  var maxValue;
  var killOwnerValue;
  var modifiedBy;

  Statistic(
      {@required var name,
      @required var value,
      @required var maxValue,
      @required StatModifiers modifiedBy,
      var killOwnerValue}) {
    this.name = name;
    this.value = value;
    this.maxValue = maxValue;
    this.modifiedBy = modifiedBy;
    if (killOwnerValue != null) {
      this.killOwnerValue = killOwnerValue;
    }
  }

  ///Returns a new Statistic instance with the same values as the passed in one.
  Statistic.clone(Statistic other) {
    name = other.name;
    value = other.value;
    maxValue = other.maxValue;
    modifiedBy = other.modifiedBy;
    killOwnerValue = other.killOwnerValue;
  }
}

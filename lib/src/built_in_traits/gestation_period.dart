import 'package:gensim/src/objects/trait.dart';
import 'package:meta/meta.dart';

class GestationPeriod extends Trait {
  //A common trait which needs to be accessed by the API via this name;
  GestationPeriod({@required cycles, maxValue})
      : super('Gestation Period', cycles, maxValue);
}

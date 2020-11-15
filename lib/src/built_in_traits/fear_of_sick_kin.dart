import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class FearOfSickKin extends Trait {
  //A common trait which needs to be accessed by the API via this name;
  FearOfSickKin({@required avoidBelowHealth})
      : super('fear of sick kin', avoidBelowHealth, 100);
}

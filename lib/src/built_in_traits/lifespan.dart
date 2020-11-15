import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

class LifeSpan extends Trait {
  ///A common trait which needs to be accessed by the API via this name;
  LifeSpan({@required int cycles, @required int maxCycles})
      : super('lifespan', cycles, maxCycles);
}

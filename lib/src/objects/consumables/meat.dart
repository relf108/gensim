import 'package:gensim/gensim.dart';
import 'package:meta/meta.dart';

///A type of consumeable which is attached to a prey.
///When a predator eats the prey the predator consumes this consumable.
class Meat extends Consumable {
  Meat({@required int value}) : super(value: value);
}

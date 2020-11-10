import 'package:gensim/src/extendable_classes/actor.dart';
import 'package:gensim/src/objects/consumeables/consumable.dart';

import 'package:meta/meta.dart';

class Meat extends Consumable {
  Meat({@required int value}) : super(value: value){
  }
}

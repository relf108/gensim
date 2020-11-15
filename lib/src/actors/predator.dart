import 'package:gensim/gensim.dart';


///Extend this class to create your own predators.
abstract class Predator<T extends Actor<T>> implements Actor<T> {}

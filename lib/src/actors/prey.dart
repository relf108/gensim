import 'package:gensim/gensim.dart';

///Extend this class to create you own prey animals
abstract class Prey<T extends Actor<T>> implements Actor<T> {}

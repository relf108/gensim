import 'dart:math';

///A point in the simulation
class SimPoint extends Point {
  List contents;
  @override
  int x;
  @override
  int y;

  SimPoint(int x, int y) : super(x, y) {
    this.x = x;
    this.y = y;
    contents = [];
  }
}

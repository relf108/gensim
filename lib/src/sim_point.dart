import 'dart:math';

class SimPoint extends Point {
  @override
  int x;
  @override
  int y;
  List contents;
  SimPoint(int x, int y) : super(x, y) {
    this.x = x;
    this.y = y;
  }
}

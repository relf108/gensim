import 'package:gensim/gensim.dart';

class SimShow {
  static void printSim(Simulation sim) {
    sim.size;
    var printStr = '';
    for (var y = 0; y < sim.size.y; y++) {
      printStr += '\n';
      for (var x = 0; x < sim.size.x; x++) {
        var point = sim.points
            .firstWhere((element) => element.x == x && element.y == y);
        if (point.contents.isNotEmpty) {
          printStr +=
              ('|${point.contents.first.runtimeType}${point.contents.length}|');
        } else {
          printStr += ('|  EMPTY  |');
        }
      }
    }
    print(printStr);
  }
}

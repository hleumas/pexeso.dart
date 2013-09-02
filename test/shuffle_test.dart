/**
 * Unittests for shuffle library.
 */
library pexeso_test.dart;

import 'package:unittest/unittest.dart';
import 'package:pexeso/shuffle.dart';

void main() {

  test("Shuffle do not change the items", () {
    var stuff = new Set.from(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']);
    var shuffled = shuffle(stuff);
    var shuffledSet = new Set.from(shuffled);
    expect(shuffledSet.length, equals(stuff.length));
    expect(shuffledSet.difference(stuff).length, equals(0));
  });

}
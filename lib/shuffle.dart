library shuffle;

import 'dart:math';

/**
 * Returns randomly shuffled [List] containing elements from [source].
 */
List shuffle(Iterable source) {
  var result = [];
  var random = new Random();
  var i = 0;
  for (var item in source) {
    result.add(item);
    var pos = random.nextInt(i+1);
    result[i] = result[pos];
    result[pos] = item;
    i++;
  }

  return result;
}
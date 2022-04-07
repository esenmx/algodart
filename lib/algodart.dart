library algodart;

import 'dart:math';

abstract class Algo {
  static List<List<MapEntry<T, T>>> roundRobinCircle<T>(List<T> elements,
      [bool rematch = true]) {
    if (elements.length < 2) {
      throw ArgumentError(elements);
    }

    final fixed = elements[0];
    final rotation = [
      ...elements.sublist(1, elements.length),
      if (elements.length % 2 != 0) null
    ];

    final schedule = List<List<MapEntry<T, T>>>.generate(
        rotation.length * (rematch ? 2 : 1), (index) => <MapEntry<T, T>>[]);

    for (int i = 0; i < rotation.length; i++) {
      final add = (T key, T value) {
        if (i % 2 == 0) {
          schedule[i].add(MapEntry(key, value));
        } else {
          schedule[i].add(MapEntry(value, key));
        }
        if (rematch) {
          if (i % 2 == 0) {
            schedule[i + rotation.length].add(MapEntry(value, key));
          } else {
            schedule[i + rotation.length].add(MapEntry(key, value));
          }
        }
      };
      final fixedMatch = rotation[i];
      if (fixedMatch != null) {
        add(fixed, fixedMatch);
      }

      for (int j = 1; j <= rotation.length ~/ 2; j++) {
        final key = rotation[(i + j) % rotation.length];
        final value = rotation[(i - j) % rotation.length];
        if (key != null && value != null) {
          add(key, value);
        }
      }
    }

    return schedule;
  }

  /// https://wikimedia.org/api/rest_v1/media/math/render/svg/fd03ce9abc4557d7190ad05b34a7ab96d3daec45
  /// [z] can be 1~2
  static double wilsonScoreInterval(int up, int down, {double z = 1.28}) {
    if (up == 0 && down == 0) {
      return 0.0;
    }
    if (up == 0) {
      return -wilsonScoreInterval(down, up);
    }
    final n = up + down;
    final p = up / n; // phat
    return (p + z * z / (2 * n) - z * sqrt(p * (1 - p) + z * z / (4 * n)) / n) /
        (1 + z * z / n);
  }
}

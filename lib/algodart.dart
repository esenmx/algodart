library algodart;

import 'dart:math';

abstract class Algo {
  static final _roundRobingCircleRng = Random();

  static List<Map<T, T>> roundRobinCircle<T>(
    List<T> elements, [
    bool rematch = true,
  ]) {
    assert(
      elements.length == elements.toSet().length,
      'teams has duplicate:\n$elements',
    );
    if (elements.length < 2) {
      throw ArgumentError(elements, 'multiple teams required');
    }

    final shuffled = [...elements]..shuffle(_roundRobingCircleRng);
    final fixed = shuffled.first;
    final rotation = [
      ...shuffled.where((element) => element != fixed),
      if (shuffled.length % 2 != 0) null
    ];

    final schedule = List<Map<T, T>>.generate(
        rotation.length * (rematch ? 2 : 1), (index) => <T, T>{});

    for (int i = 0; i < rotation.length; i++) {
      void add(T key, T value, int j) {
        if (j % 2 == 0) {
          schedule[i][key] = value;
          if (rematch) {
            schedule[i + rotation.length][value] = key;
          }
        } else {
          schedule[i][value] = key;
          if (rematch) {
            schedule[i + rotation.length][key] = value;
          }
        }
      }

      /// Matching for Fixed
      if (rotation[i] != null) {
        add(fixed, rotation[i] as T, i);
      }

      for (int j = 1; j <= rotation.length ~/ 2; j++) {
        final key = rotation[(i + j) % rotation.length];
        final value = rotation[(i - j) % rotation.length];
        if (key != null && value != null) {
          add(key, value, j);
        }
      }
    }

    return schedule;
  }

  /// https://wikimedia.org/api/rest_v1/media/math/render/svg/fd03ce9abc4557d7190ad05b34a7ab96d3daec45
  /// [z] can be 1~2
  static double wilsonScoreInterval(int up, int down, {double z = 1.61}) {
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

extension SetX<E> on Set<E> {
  Set<E> subset(int start, [int? end]) {
    RangeError.checkValidRange(start, end, length);
    final s = <E>{};
    for (var i = start; i < (end ?? length); i++) {
      s.add(elementAt(i));
    }
    return s;
  }
}

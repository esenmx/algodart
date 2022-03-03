import 'package:algodart/algodart.dart';
import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

void main() async {
  group('RoundRobin', () {
    _testRoundRobinCircle(2.range(1), false);
    _testRoundRobinCircle(2.range(1));
    _testRoundRobinCircle(31.range(1));
    _testRoundRobinCircle(31.range(1), false);
    _testRoundRobinCircle(32.range(1));
    _testRoundRobinCircle(32.range(1), false);
  });
}

void _testRoundRobinCircle(List<int> elements, [bool rematch = true]) {
  test('roundRobinCircle(${elements.length}, $rematch)', () {
    final schedule =
        Algo.roundRobinCircle(elements, rematch).expand((element) => element);
    for (var e in elements) {
      final keys = schedule.fold<int>(0, (pv, v) => pv + (v.key == e ? 1 : 0));
      final values =
          schedule.fold<int>(0, (pv, v) => pv + (v.value == e ? 1 : 0));
      if (rematch) {
        expect(keys, values);
      }
      expect(keys + values, (elements.length - 1) * (rematch ? 2 : 1));
    }
  });
}

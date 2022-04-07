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

  test('WilsonScoreInterval', () {
    expect(Algo.wilsonScoreInterval(1, 0),
        greaterThan(Algo.wilsonScoreInterval(0, 0)));
    expect(Algo.wilsonScoreInterval(1, 0),
        greaterThan(Algo.wilsonScoreInterval(1, 1)));
    expect(Algo.wilsonScoreInterval(5, 0),
        greaterThan(Algo.wilsonScoreInterval(4, 0)));
    expect(Algo.wilsonScoreInterval(11, 0),
        greaterThan(Algo.wilsonScoreInterval(10, 0)));
    expect(Algo.wilsonScoreInterval(10, 0),
        greaterThan(Algo.wilsonScoreInterval(20, 10)));
    expect(Algo.wilsonScoreInterval(10, 0),
        greaterThan(Algo.wilsonScoreInterval(11, 1)));
    expect(Algo.wilsonScoreInterval(10, 10, z: 1.99),
        greaterThan(Algo.wilsonScoreInterval(10, 10, z: 2)));
  });
}

void _testRoundRobinCircle(List<int> elements, [bool rematch = true]) {
  test('roundRobinCircle(${elements.length}, $rematch)', () {
    final schedule = Algo.roundRobinCircle(elements, rematch).expand((e) => e);
    for (var e in elements) {
      final keys = schedule.fold<int>(0, (pv, v) {
        return pv + (v.key == e ? 1 : 0);
      });
      final values = schedule.fold<int>(0, (pv, v) {
        return pv + (v.value == e ? 1 : 0);
      });
      if (rematch) {
        expect(keys, equals(values));
      }
      expect(keys + values, equals((elements.length - 1) * (rematch ? 2 : 1)));
    }
  });
}

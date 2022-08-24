import 'dart:math';

import 'package:algodart/algodart.dart';
import 'package:test/test.dart';
import 'package:test_utils/test_utils.dart';

void main() async {
  group('RoundRobin', () {
    _testRoundRobinCircle(2.range(1), false);
    _testRoundRobinCircle(2.range(1));
    _testRoundRobinCircle(6.range(1));
    _testRoundRobinCircle(6.range(1), false);
    _testRoundRobinCircle(7.range(1));
    _testRoundRobinCircle(7.range(1), false);
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

void _testRoundRobinCircle(List<int> units, [bool rematch = true]) {
  test('roundRobinCircle(${units.length}, $rematch)', () {
    final schedule = Algo.roundRobinCircle(units, rematch);
    printOnFailure('$units\n${schedule.join('\n')}');
    final flatSchedule = schedule.expand((e) => e.entries);
    for (var unit in units) {
      final lCount = flatSchedule.fold<int>(0, (previousValue, value) {
        return previousValue + (value.key == unit ? 1 : 0);
      });
      final rCount = flatSchedule.fold<int>(0, (previousValue, value) {
        return previousValue + (value.value == unit ? 1 : 0);
      });
      if (rematch) {
        expect(
          lCount,
          equals(rCount),
          reason: unit.toString(),
        );
        expect(
          lCount + rCount,
          equals((units.length - 1) * 2),
          reason: unit.toString(),
        );
      } else {
        expect(
          (5).range(max(lCount - 2, 0)),
          contains(rCount),
          reason: unit.toString(),
        );
        expect(
          lCount + rCount,
          equals(units.length - 1),
          reason: unit.toString(),
        );
      }
    }
  });
}

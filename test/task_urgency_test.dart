import 'package:app_front/features/tasks/view/widgets/task_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 9, 15, 12);

  test('task urgency follows deadline thresholds', () {
    expect(
      urgencyForDeadline(now.add(const Duration(minutes: 30)), now: now),
      TaskUrgency.critical,
    );
    expect(
      urgencyForDeadline(now.add(const Duration(hours: 4)), now: now),
      TaskUrgency.urgent,
    );
    expect(
      urgencyForDeadline(now.add(const Duration(days: 2)), now: now),
      TaskUrgency.soon,
    );
    expect(
      urgencyForDeadline(now.add(const Duration(days: 5)), now: now),
      TaskUrgency.normal,
    );
  });
}

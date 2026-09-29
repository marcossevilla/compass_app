import 'dart:async';

import 'package:compass_app/routing/routing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(StreamValueNotifier, () {
    test('starts with the initial value', () {
      final notifier = StreamValueNotifier(
        const Stream<bool>.empty(),
        initialValue: false,
      );
      addTearDown(notifier.dispose);

      expect(notifier.value, isFalse);
    });

    test('updates its value and notifies listeners on stream events', () async {
      final controller = StreamController<bool>();
      addTearDown(controller.close);
      final notifier = StreamValueNotifier(
        controller.stream,
        initialValue: false,
      );
      addTearDown(notifier.dispose);
      var notifications = 0;
      notifier.addListener(() => notifications++);

      controller.add(true);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.value, isTrue);
      expect(notifications, equals(1));
    });

    test('cancels the stream subscription on dispose', () async {
      final controller = StreamController<bool>();
      addTearDown(controller.close);
      StreamValueNotifier(controller.stream, initialValue: false).dispose();
      await Future<void>.delayed(Duration.zero);

      expect(controller.hasListener, isFalse);
    });
  });
}

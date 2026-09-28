import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [ValueNotifier] that mirrors the latest value emitted by a [Stream].
///
/// Lets a [Stream] drive anything that listens to a [Listenable], such as
/// `GoRouter.refreshListenable`. The subscription is cancelled on [dispose].
class StreamValueNotifier<T> extends ValueNotifier<T> {
  new(Stream<T> stream, {required T initialValue})
    : super(initialValue) {
    _subscription = stream.listen((event) => value = event);
  }

  late final StreamSubscription<T> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

import 'dart:async';

/// Collection of helpers for completers.
mixin CompleterHelper {
  /// Wraps the given future with a completer.
  static Completer<T> wrapCompleter<T>(Future<T> future) {
    final Completer<T> completer = Completer<T>();
    future.then(completer.complete).catchError(completer.completeError);
    return completer;
  }
}

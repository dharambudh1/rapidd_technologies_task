import "dart:async";

import "package:flutter/foundation.dart";

class DebounceUtil {
  factory DebounceUtil() {
    return _singleton;
  }

  DebounceUtil._internal();
  static final DebounceUtil _singleton = DebounceUtil._internal();

  Timer timer = Timer(Duration.zero, () {});

  void debounce(VoidCallback callback) {
    if (timer.isActive) {
      timer.cancel();
    }

    timer = Timer(const Duration(seconds: 1), callback);

    return;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class Bloc {
  StreamController<ThemeMode> _themeModeStreamController = StreamController();
  Stream<ThemeMode> themeModeStream;

  ThemeMode themeMode;
  Bloc() {
    themeModeStream = _themeModeStreamController.stream.asBroadcastStream()
      ..listen((data) {
        themeMode = data;
      });
    _themeModeStreamController.sink.add(ThemeMode.system);
  }

  dispose() {
    _themeModeStreamController.close();
  }

  bool isDarkTheme(BuildContext context) {
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
  }

  void updateBrightness(BuildContext context) {
    _themeModeStreamController.sink
        .add(isDarkTheme(context) ? ThemeMode.light : ThemeMode.dark);
  }
}

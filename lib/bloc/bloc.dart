import 'dart:async';

import 'package:flutter/services.dart';

class Bloc {

  StreamController<Brightness> _brightnessStreamController = StreamController();
  Stream<Brightness> brightnessStream;

  Brightness brightness;
  Bloc() {
    brightnessStream = _brightnessStreamController.stream.asBroadcastStream()
      ..listen((data) {
        brightness = data;
      });
    _brightnessStreamController.sink.add(Brightness.light);
  }


  dispose() {
    _brightnessStreamController.close();
  }

  void updateBrightness() {
    _brightnessStreamController.sink.add(
        brightness == Brightness.dark ? Brightness.light : Brightness.dark);
  }
}

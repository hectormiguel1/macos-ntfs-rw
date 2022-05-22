import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider.autoDispose<SwatchNotifier>((ref) {
  ref.maintainState = true;
  return SwatchNotifier();
});

class SwatchNotifier with ChangeNotifier {
  MaterialColor _primaryColor = Colors.blue;
  late Brightness _brightness = Brightness.dark;

  MaterialColor get theme => _primaryColor;
  Brightness get brightness => _brightness;

  set theme(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }

  void toggleBrightness() {
    _brightness =
        _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    notifyListeners();
  }

  set brightness(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

final toggleWidgetProvider = StateNotifierProvider<ToggleWidget, bool>((ref) {
  return ToggleWidget();
});

class ToggleWidget extends StateNotifier<bool> {
  ToggleWidget() : super(false);

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

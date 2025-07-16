import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_flow/unit_test/bool_provider.dart';


void main() {
  group("Dark Theme", () {
    late ToggleWidget toggleWidget;
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      toggleWidget = container.read(toggleWidgetProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test("initial state should be false", () {
      expect(container.read(toggleWidgetProvider), false);
    });
    test("toggle() should change state to true/false", () {
      toggleWidget.toggle();
      expect(container.read(toggleWidgetProvider), true);

      toggleWidget.toggle();
      expect(container.read(toggleWidgetProvider), false);
    });

    test("setValue() should set state to given value", () {
      toggleWidget.setValue(true);
      expect(container.read(toggleWidgetProvider), true);

      toggleWidget.setValue(false);
      expect(container.read(toggleWidgetProvider), false);
    });
  });
}

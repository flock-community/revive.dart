import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> Function(WidgetTester tester) iphone8(WidgetTesterCallback callback) {
  return (tester) async {
    debugDisableShadows = false;
    tester.binding.window.physicalSizeTestValue = Size(414.0 * 2, 736.0 * 2);
    tester.binding.window.devicePixelRatioTestValue = 2;
    await loadAppFonts();
    await callback(tester);
    debugDisableShadows = true;
  };
}

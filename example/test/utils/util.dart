import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:rxdart/rxdart.dart';

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

extension X on WidgetTester {
  Future<List<Effect>> collectEffects(Subject<Effect> effects, Future<void> Function() future) async {
    return (await this.runAsync(() => effects.collect(future)))!;
  }
}

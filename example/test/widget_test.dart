// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/main.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:rxdart/rxdart.dart';

import 'utils/util.dart';

void main() {
  testWidgets('MyApp', iphone8((tester) async {
    var todo = todoMock(description: 'Make revive');
    var $ = TestContext([todo]);

    await tester.pumpWidget(View($));
    await expectLater(find.byType(View), matchesGoldenFile('goldens/MyApp.png'));
  }));
}

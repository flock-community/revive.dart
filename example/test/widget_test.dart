import 'package:flutter_test/flutter_test.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/main.dart';
import 'package:revive_example/mock/todo.dart';

import 'utils/util.dart';

void main() {
  testWidgets('MyApp', iphone8((tester) async {
    var todo = todoMock(description: 'Make revive');
    var $ = TestContext([todo]);

    await tester.pumpWidget(View($));
    await expectLater(find.byType(View), matchesGoldenFile('goldens/MyApp.png'));
  }));
}

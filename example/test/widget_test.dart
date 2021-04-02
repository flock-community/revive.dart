import 'package:flutter_test/flutter_test.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/view/view.dart';

import 'utils/util.dart';

void main() {
  testWidgets('View', iphone8((tester) async {
    final todo = todoMock(description: 'Make revive');
    final $ = TestContext.fromMocks(todos: [todo]);
    await tester.pumpWidget(View($));
    await expectLater(find.byType(View), matchesGoldenFile('goldens/View.png'));
  }));
}

import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/kt.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/event/todo_events.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/view/view.dart';

import 'utils/util.dart';

void main() {
  final todo = todoMock(TestLayer(), description: 'Brainstorm blogpost');
  final updatedTodo = todo.copyWith(completed: true);

  group('on todo completed', () {
    testWidgets('both state and backend are updated', iphone8((tester) async {
      final $ = TestContext.fromMocks(todos: [todo]);

      await tester.pumpWidget(View($));
      await expectLater(find.byType(View), matchesGoldenFile('goldens/before_completed.png'));

      final effects = await $.collectEffects(() => onTodoCompleted($, TodoCompleted(todo)));
      expect(effects, [
        Output($.todos.revive, [updatedTodo].done()),
        Output($.todoRepo.update, updatedTodo),
      ]);

      await tester.pumpWidget(View($));
      await expectLater(find.byType(View), matchesGoldenFile('goldens/after_completed.png'));
    }));

    test('on backend failure state is rolled back', () async {
      final $ = TestLayer().let(($) => TestContext(
            layer: $,
            todoRepo: TestRepository($, [todo], update: (models, model) => throw Exception()),
            todos: TestStateStream($, [todo].done()),
          ));

      final effects = await $.collectEffects(() => onTodoCompleted($, TodoCompleted(todo)));
      expect(effects, [
        Output($.todos.revive, [updatedTodo].done()),
        Output($.todoRepo.update, updatedTodo),
        Output($.todos.revive, [todo].done()),
      ]);
    });
  });
}

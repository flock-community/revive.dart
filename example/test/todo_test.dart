import 'package:flutter_test/flutter_test.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/event/todo_events.dart';
import 'package:revive_example/main.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive/model/model.dart';
import 'package:rxdart/rxdart.dart';

import 'utils/util.dart';

void main() {
  group('on todo completed', () {
    testWidgets('both state and backend are updated', iphone8((tester) async {
      final todo = todoMock(description: 'Brainstorm blogpost');
      final $ = TestContext([todo]);
      await tester.pumpWidget(View($));
      await expectLater(find.byType(View), matchesGoldenFile('goldens/before_completed.png'));

      final updatedTodo = todo.copyWith(completed: true);
      final effects = await tester.runAsync(() => $.effects.collect(() => onTodoCompleted($, TodoCompleted(todo))));
      expect(
        effects,
        [
          Output($.todos.revive, [todo].update(updatedTodo)),
          Output($.todoRepo.update, updatedTodo),
        ],
      );

      await tester.pumpWidget(View($));
      await expectLater(find.byType(View), matchesGoldenFile('goldens/after_completed.png'));
    }));

    test('on backend failure state is rolled back', () async {
      final todo = todoMock(description: '');
      final $ = TestContext([todo]).build(($) => $..todoRepo = ErrorTodoRepo($.effects));
      final updatedTodo = todo.copyWith(completed: true);

      expect(
        await $.effects.collect(() => onTodoCompleted($, TodoCompleted(todo))),
        [
          Output($.todos.revive, [todo].update(updatedTodo)),
          Output($.todoRepo.update, updatedTodo),
          Output($.todos.revive, [todo]),
        ],
      );
    });
  });
}

class ErrorTodoRepo extends TestRepository<Todo> implements Repository<Todo> {
  ErrorTodoRepo(Subject<Effect> effects) : super([], effects);

  Future<void> update(Todo model) async {
    await super.update(model);
    throw Exception();
  }
}

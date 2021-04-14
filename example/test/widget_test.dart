import 'package:flutter_test/flutter_test.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/model/todo_form.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/view/view.dart';
import 'utils/util.dart';

List<Todo> someTodos(TestLayer $) {
  return [
    todoMock($, description: 'Something'),
    todoMock($, description: 'Something for today', dueDate: $.clock.now()),
    todoMock($, description: 'Something for tomorrow', dueDate: $.clock.now().add(Duration(days: 1))),
    todoMock($, description: 'Something for later', dueDate: $.clock.now().add(Duration(days: 10))),
  ];
}

void main() {
  group('Inbox', () {
    testWidgets('some todos', iphone8((tester) async {
      await tester.expectWidgetToMatchFile(
        View(TestLayer().let(($) => TestContext.fromData(todos: someTodos($), route: Route.inbox()))),
        'golden/Inbox/some_todos.png',
      );
    }));

    testWidgets('completed todo', iphone8((tester) async {
      await tester.expectWidgetToMatchFile(
        TestLayer()
            .let(($) => TestContext.fromData(
                  todos: [todoMock($, description: 'Something', completed: true)],
                  route: Route.inbox(),
                ))
            .let(($) => View($)),
        'golden/Inbox/completed_todo.png',
      );
    }));
  });

  group('Today', () {
    testWidgets('some todos', iphone8((tester) async {
      await tester.expectWidgetToMatchFile(
        TestLayer() //
            .let(($) => TestContext.fromData(todos: someTodos($), route: Route.today()))
            .let(($) => View($)),
        'golden/Today/some_todos.png',
      );
    }));
  });

  group('Today', () {
    testWidgets('empty form', iphone8((tester) async {
      await tester.expectWidgetToMatchFile(
        TestLayer()
            .let(($) => TestContext.fromData(todos: someTodos($), route: Inbox(CreateTodoModal(form: TodoForm()))))
            .let(($) => View($)),
        'golden/CreateTodo/empty_form.png',
      );
    }));

    testWidgets('submitting form', iphone8((tester) async {
      await tester.expectWidgetToMatchFile(
        TestLayer()
            .let(($) => TestContext.fromData(
                todos: someTodos($),
                route: Inbox(CreateTodoModal(
                  form: TodoForm(
                    submitting: true,
                    description: 'hello',
                    dueDate: $.clock.now(),
                  ),
                ))))
            .let(($) => View($)),
        'golden/CreateTodo/submitting_form.png',
      );
    }));
  });
}

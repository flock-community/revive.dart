import 'package:revive/model/async.dart';
import 'package:revive_example/event/router.dart';
import 'package:revive_example/event/undo_todo_message.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';

abstract class OnTodoCompleted implements TodoRepo, Todos {}

Future<void> onTodoCompleted(OnTodoCompleted $, TodoCompleted event) async {
  final newTodo = event.todo.copyWith(completed: true);
  $.todos.revive((it) => it.update(newTodo));
  try {
    await $.todoRepo.update(newTodo);
  } catch (e) {
    // rollback
    $.todos.revive((it) => it.update(event.todo));
  }
}

abstract class OnTodoFormSubmitted
    implements UndoTodoMessage, Messenger, CreateTodo, RouteTo, RouteState, TodoRepo, Todos {}

Future<void> onTodoFormSubmitted(OnTodoFormSubmitted $, TodoFormSubmitted event) async {
  var modal = event.modal;
  $.route.revive((it) => it.updateModal(modal.copyWith(submitting: true)));
  try {
    var todo = createTodo($, description: event.description);
    await $.todoRepo.create(todo);
    $.todos.revive((it) => it.create(todo));
    $.messenger.showSnackBar(undoTodoMessage($, todo));
    await routeTo($, $.route.state.copyWith(modal: null));
  } catch (_) {
    $.route.revive((it) => it.updateModal(modal.copyWith(submitting: false)));
    rethrow;
  }
}

abstract class OnStartApp implements RouteTo {}

Future<void> onStartApp(OnStartApp $, AppStarted event) async {
  await routeTo($, Route.inbox());
}

abstract class OnTodayOpened implements RouteTo {}

Future<void> onTodayOpened(RouteTo $, TodayOpened event) async {
  await routeTo($, Route.today());
}

abstract class OnInboxOpened implements RouteTo {}

Future<void> onInboxOpened(OnInboxOpened $, InboxOpened event) async {
  await routeTo($, Route.inbox());
}

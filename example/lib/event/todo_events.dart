import 'package:revive/model/async.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
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

abstract class OnStartApp implements RouteState, Todos, TodoRepo {}

Future<void> onStartApp(OnStartApp $, AppStarted event) async {
  var future = $.todos.setFromStream($.todos.state.load(() => $.todoRepo.getAll()));
  $.route.state = Route.inbox();
  await future;
}

abstract class OnTodayOpened implements RouteState, Todos, TodoRepo {}

Future<void> onTodayOpened(OnTodayOpened $, TodayOpened event) async {
  var future = $.todos.setFromStream($.todos.state.load(() => $.todoRepo.getAll()));
  $.route.state = Route.today();
  await future;
}

abstract class OnInboxOpened implements RouteState, Todos, TodoRepo {}

Future<void> onInboxOpened(OnInboxOpened $, InboxOpened event) async {
  var future = $.todos.setFromStream($.todos.state.load(() => $.todoRepo.getAll()));
  $.route.state = Route.inbox();
  await future;
}

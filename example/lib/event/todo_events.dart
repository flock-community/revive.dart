import 'package:revive/model/async.dart';
import 'package:revive_example/event/router.dart';
import 'package:revive_example/event/undo_todo_message.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/model/todo_form.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';

abstract class OnTodoCompleted implements TodoRepo, Todos {}

Future<void> onTodoCompleted(OnTodoCompleted $, TodoCompleted event) async {
  final newTodo = event.todo.copyWith(completed: !event.todo.completed);
  $.todos.revive((it) => it.update(newTodo));
  try {
    await $.todoRepo.update(newTodo);
  } catch (e) {
    // rollback
    $.todos.revive((it) => it.update(event.todo));
  }
}

abstract class OnCreateTodoFormSubmitted
    implements TodoFormConsume, RouteState, TodoRepo, Todos, UndoTodoMessage, Messenger, RouteTo {}

Future<void> onCreateTodoFormSubmitted(OnCreateTodoFormSubmitted $, CreateTodoFormSubmitted event) async {
  final modal = event.modal;
  final todo = modal.form.consume($);
  $.route.revive((it) => it.updateModal(modal.copyWith.form(submitting: true)));
  try {
    await $.todoRepo.create(todo);
    $.todos.revive((it) => it.create(todo));
    $.messenger.showSnackBar(undoTodoMessage($, todo));
    await routeTo($, $.route.state.copyWith(modal: null));
  } catch (_) {
    $.route.revive((it) => it.updateModal(modal.copyWith.form(submitting: false)));
    rethrow;
  }
}

abstract class OnUpdateTodoFormSubmitted implements RouteState, TodoRepo, Todos, RouteTo {}

Future<void> onUpdateTodoFormSubmitted(OnUpdateTodoFormSubmitted $, UpdateTodoFormSubmitted event) async {
  final modal = event.modal, todo = modal.todo, form = modal.form;
  final updatedTodo = todo.updateFromForm(form);
  $.route.revive((it) => it.updateModal(modal.copyWith.form(submitting: true)));
  try {
    await $.todoRepo.update(updatedTodo);
    $.todos.revive((it) => it.update(updatedTodo));
    await routeTo($, $.route.state.copyWith(modal: null));
  } catch (_) {
    $.route.revive((it) => it.updateModal(modal.copyWith.form(submitting: false)));
    rethrow;
  }
}

abstract class OnAppStarted implements RouteTo {}

Future<void> onAppStarted(OnAppStarted $, AppStarted event) async {
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

abstract class OnAppReloaded implements RouteTo {}

Future<void> onAppReloaded(OnAppReloaded $, AppReloaded event) async {
  await routeTo($, $.route.state);
}

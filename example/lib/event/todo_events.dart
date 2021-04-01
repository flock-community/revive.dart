import 'package:revive/model/revive.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';

abstract class OnTodoCompleted implements TodoRepo, Todos {}

Future<void> onTodoCompleted(OnTodoCompleted $, TodoCompleted event) async {
  final newTodo = event.todo.copyWith(completed: true);
  $.todos.revive(update(newTodo));
  try {
    await $.todoRepo.update(newTodo);
  } catch (e) {
    // rollback
    $.todos.revive(update(event.todo));
  }
}

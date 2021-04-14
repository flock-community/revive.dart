import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';
import 'package:revive/model/async.dart';
import 'package:revive/service/clock.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive/service/id_generator.dart';
import 'package:revive_example/model/todo_form.dart';
import 'package:revive_example/util/extensions.dart';

part 'todo.freezed.dart';

part 'todo.g.dart';

@freezed
class Todo with _$Todo implements Model {
  const factory Todo({
    required String id,
    required String description,
    required bool completed,
    required DateTime createdAt,
    DateTime? dueDate,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

abstract class CreateTodo implements WithClock, WithIdGenerator {}

Todo createTodo(
  CreateTodo $, {
  required String description,
  bool completed = false,
  DateTime? dueDate,
}) {
  return Todo(
    createdAt: $.clock.now(),
    id: $.id.generate(),
    description: description,
    completed: completed,
    dueDate: dueDate,
  );
}

extension XTodo on Todo {
  bool dueToday(DateTime now) => dueDate?.isAtSameDayAs(now) ?? false;

  TodoForm asForm() => TodoForm(description: description, dueDate: dueDate, submitting: false);
}

extension XTodos on List<Todo> {
  Done<List<Todo>, AsyncException> done() => Done(this, loading: false);
}

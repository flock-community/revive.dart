import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';
import 'package:revive/model/async.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive_example/service/id_generator.dart';
import 'package:time/time.dart';

part 'todo.freezed.dart';

part 'todo.g.dart';

@freezed
class Todo with _$Todo implements Model {
  const factory Todo({
    required String id,
    required String description,
    required bool completed,
    DateTime? dueDate,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

abstract class CreateTodo implements WithIdGenerator {}

Todo createTodo(
  CreateTodo $, {
  required String description,
  bool completed = false,
  DateTime? dueDate,
}) {
  return Todo(
    id: $.id.generate(),
    description: description,
    completed: completed,
    dueDate: dueDate,
  );
}

extension TodoX on Todo {
  bool dueToday() => this.dueDate?.isToday ?? false;
}

extension TodosX on List<Todo> {
  Done<List<Todo>, AsyncException> done() => Done(this, loading: false);
}

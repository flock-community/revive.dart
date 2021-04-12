import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_example/model/todo.dart';

part 'todo_form.freezed.dart';
part 'todo_form.g.dart';

@freezed
class TodoForm with _$TodoForm {
  const factory TodoForm({
    @Default('') String description,
    @Default(false) bool submitting,
    DateTime? dueDate,
  }) = _TodoForm;

  factory TodoForm.fromJson(Map<String, dynamic> json) => _$TodoFormFromJson(json);
}

abstract class TodoFormConsume implements CreateTodo {}

extension XTodoForm on TodoForm {
  Todo consume(TodoFormConsume $) => createTodo($, description: description, dueDate: dueDate);
}

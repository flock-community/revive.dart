import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/id_generator.dart';

abstract class TodoMock implements WithIdGenerator {}

Todo todoMock(
  TodoMock $, {
  String? id,
  String description = 'todo',
  bool completed = false,
  DateTime? dueDate,
}) {
  return Todo(
    id: id ?? $.id.generate(),
    description: description,
    completed: completed,
    dueDate: dueDate,
  );
}

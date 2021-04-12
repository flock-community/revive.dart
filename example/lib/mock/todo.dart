import 'package:revive/service/clock.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive/service/id_generator.dart';

abstract class TodoMock implements WithClock, WithIdGenerator {}

Todo todoMock(
  TodoMock $, {
  String? id,
  String description = 'todo',
  bool completed = false,
  DateTime? dueDate,
}) {
  return Todo(
    createdAt: $.clock.now(),
    id: id ?? $.id.generate(),
    description: description,
    completed: completed,
    dueDate: dueDate,
  );
}

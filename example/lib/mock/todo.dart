import 'package:revive_example/model/todo.dart';

Todo todoMock({
  String id = '0',
  String description = 'todo',
  bool completed = false,
  DateTime? dueDate,
}) {
  return Todo(
    id: id,
    description: description,
    completed: completed,
    dueDate: dueDate,
  );
}

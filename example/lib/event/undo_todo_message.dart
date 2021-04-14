import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/widgets.dart';
import 'package:revive/model/async.dart';

abstract class UndoTodoMessage implements Messenger, TodoRepo, Todos {}

SnackBar undoTodoMessage(UndoTodoMessage $, Todo todo) {
  return SnackBar(
    content: Text('Added todo ${todo.description}'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () async {
        $.todos.revive((state) => state.delete(todo.id));
        await $.todoRepo.delete(todo.id);
      },
    ),
  );
}

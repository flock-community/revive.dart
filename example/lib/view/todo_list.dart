import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/view/todo_tile.dart';
import 'package:revive_example/widgets.dart';

abstract class TodoListContext implements TodoTileContext {}

class TodoList extends HookWidget {
  const TodoList(this.$, this.todos);

  final TodoListContext $;
  final Iterable<Todo> todos;

  Widget build(context) {
    return ListView(
      children: [
        for (var todo in todos.where((it) => !it.completed)) TodoTile($, todo),
        for (var todo in todos.where((it) => it.completed)) TodoTile($, todo),
      ],
    );
  }
}

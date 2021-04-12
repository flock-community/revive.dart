import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/widgets.dart';

abstract class TodoListContext implements TodoTileContext {}

class TodoList extends HookWidget {
  const TodoList(this.$, this.todos);

  final TodoListContext $;
  final Iterable<Todo> todos;

  Widget build(context) {
    return ListView(
      children: [
        for (var todo in todos) ...[TodoTile($, todo), Divider()]
      ],
    );
  }
}

abstract class TodoTileContext implements EventStream {}

class TodoTile extends StatelessWidget {
  TodoTile(this.$, this.todo);

  final TodoTileContext $;
  final Todo todo;

  Widget build(BuildContext context) {
    return ListTile(
      key: Key(todo.id),
      leading: IconButton(
        onPressed: todo.completed ? null : () => $.events.add(TodoCompleted(todo)),
        icon: Icon(
          todo.completed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: todo.completed ? Theme.of(context).primaryColor : null,
        ),
      ),
      title: Text(todo.description),
      subtitle: todo.dueDate?.let((it) => Text(DateFormat('d MMMM yyyy').format(it))),
    );
  }
}

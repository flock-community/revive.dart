import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/todos.dart';

abstract class TodoListContext implements Todos, TodoTileContext {}

class TodoList extends HookWidget {
  TodoList(this.$);

  final TodoListContext $;

  Widget build(context) {
    final todos = useStateStream($.todos, $.todos.stream.distinct(DeepCollectionEquality().equals));
    return ListView(children: [
      for (var todo in todos) ...[TodoTile($, todo), Divider()]
    ]);
  }
}

abstract class TodoTileContext implements EventStream {}

class TodoTile extends StatelessWidget {
  TodoTile(this.$, this.todo);

  final TodoTileContext $;
  final Todo todo;

  Widget build(context) {
    return ListTile(
      key: Key(todo.id),
      leading: IconButton(
        onPressed: todo.completed ? null : () => $.events.add(TodoCompleted(todo)),
        icon: Icon(todo.completed ? Icons.check_circle_outline : Icons.radio_button_unchecked),
      ),
      title: Text(todo.description),
    );
  }
}

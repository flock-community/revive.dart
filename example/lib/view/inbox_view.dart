import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';

abstract class InboxContext implements TodoListContext, Todos, MyScaffoldContext {}

class InboxView extends HookWidget {
  InboxView(this.$);

  final InboxContext $;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream);

    return MyScaffold(
      $,
      title: Text('Inbox'),
      body: todos.map(done: (it) => TodoList($, it.data), none: (it) => AsyncNoneView(it)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';
import 'package:revive_example/model/todo.dart';

abstract class TodayContext implements TodoListContext, MyScaffoldContext, Todos {}

class TodayView extends HookWidget {
  TodayView(this.$);

  final TodayContext $;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream);

    return MyScaffold(
      $,
      title: Text('Today'),
      body: todos.map(
        done: (it) => TodoList($, it.data.where((todo) => todo.dueToday())),
        none: (it) => AsyncNoneView(it),
      ),
    );
  }
}

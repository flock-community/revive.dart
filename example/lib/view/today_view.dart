import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/widgets.dart';

abstract class TodayContext implements TodoListContext, MyScaffoldContext, Todos, EventStream {}

class TodayView extends HookWidget {
  const TodayView(this.$);

  final TodayContext $;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream);

    return MyScaffold(
      $,
      title: Text('Today'),
      body: todos.map(
        done: (it) => RefreshIndicator(
          child: TodoList($, it.data.where((todo) => todo.dueToday())),
          onRefresh: () {
            $.events.add(Event.onTodayOpened());
            return $.todos.stream.firstWhere((it) => !it.loading);
          },
        ),
        none: (it) => AsyncNoneView(it),
      ),
    );
  }
}

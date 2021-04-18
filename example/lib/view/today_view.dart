import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive/service/clock.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/widgets.dart';

abstract class TodayContext implements TodoListContext, MyScaffoldContext, Todos, EventStream, WithClock {}

class TodayPage extends HookWidget {
  const TodayPage(this.$, this.today);

  final TodayContext $;
  final Today today;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream);

    return MyScaffold(
      $,
      title: Text('Today'),
      body: todos.map(
        done: (it) => RefreshIndicator(
          child: TodoList(
            $,
            it.data
                .where((todo) => today.showCompleted ? true : !todo.completed)
                .where((todo) => todo.dueToday($.clock.now())),
          ),
          onRefresh: () {
            $.events.add(Event.onAppReloaded());
            return $.todos.stream.firstWhere((it) => !it.loading);
          },
        ),
        none: (it) => AsyncNoneView(it),
      ),
      menu: PopupMenuButton<String>(
        onSelected: (_) {
          $.route.state = Today(showCompleted: !today.showCompleted);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'toggle_completed',
            child: today.showCompleted ? Text('Hide completed') : Text('Show completed'),
          )
        ],
      ),
    );
  }
}

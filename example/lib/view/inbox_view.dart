import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';
import 'package:revive_example/widgets.dart';

abstract class InboxContext implements EventStream, TodoListContext, Todos, MyScaffoldContext {}

class InboxPage extends HookWidget {
  const InboxPage(this.$, this.inbox);

  final InboxContext $;
  final Inbox inbox;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream, [$]);
    return MyScaffold(
      $,
      title: Text('Inbox'),
      body: todos.map(
        done: (it) => RefreshIndicator(
          onRefresh: () {
            $.events.add(Event.onAppReloaded());
            return $.todos.stream.firstWhere((it) => !it.loading);
          },
          child: TodoList($, it.data.where((todo) => inbox.showCompleted ? true : !todo.completed)),
        ),
        none: (it) => AsyncNoneView(it),
      ),
      menu: PopupMenuButton<String>(
        onSelected: (_) {
          $.route.state = Inbox(showCompleted: !inbox.showCompleted);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'toggle_completed',
            child: inbox.showCompleted ? Text('Hide completed') : Text('Show completed'),
          )
        ],
      ),
    );
  }
}

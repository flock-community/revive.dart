import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/view/async_none_view.dart';
import 'package:revive_example/view/scaffold.dart';
import 'package:revive_example/view/todo_list.dart';
import 'package:revive_example/widgets.dart';

abstract class InboxContext implements EventStream, TodoListContext, Todos, MyScaffoldContext {}

class InboxPage extends HookWidget {
  const InboxPage(this.$);

  final InboxContext $;

  Widget build(BuildContext context) {
    final todos = useStateStream($.todos.stream);
    return MyScaffold(
      $,
      title: Text('Inbox'),
      body: todos.map(
        done: (it) => RefreshIndicator(
          onRefresh: () {
            $.events.add(Event.onInboxOpened());
            return $.todos.stream.firstWhere((it) => !it.loading);
          },
          child: TodoList($, it.data),
        ),
        none: (it) => AsyncNoneView(it),
      ),
    );
  }
}

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:revive/model/async.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/widgets.dart';

abstract class TodoTileContext implements EventStream, RouteState, Todos, TodoRepo {}

class TodoTile extends HookWidget {
  TodoTile(this.$, this.todo);

  final TodoTileContext $;
  final Todo todo;

  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      closeOnScroll: true,
      child: Container(
        child: ListTile(
          onTap: () {},
          key: Key(todo.id),
          leading: IconButton(
            onPressed: () => $.events.add(TodoCompleted(todo)),
            icon: Icon(
              todo.completed ? Icons.check_circle_outline : Icons.radio_button_unchecked,
              color: todo.completed ? null : Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            todo.description,
            style: !todo.completed
                ? null
                : TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
          ),
          subtitle: todo.dueDate?.let(
            (it) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: Theme.of(context).textTheme.caption!.color,
                ),
                SizedBox(width: 3),
                Text(DateFormat('d MMMM yyyy').format(it)),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconSlideAction(
          caption: 'Edit',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () {
            $.route.revive((it) => it.addModal(UpdateTodoModal(form: todo.asForm(), todo: todo)));
          },
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () async {
            $.todos.revive((state) => state.delete(todo.id));
            await $.todoRepo.delete(todo.id);
          },
        ),
      ],
    );
  }
}

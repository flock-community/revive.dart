import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo_form.dart';
import 'package:revive_example/service/events.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/view/todo_form.dart';
import 'package:revive_example/widgets.dart';

abstract class MyScaffoldContext implements RouteState, EventStream {}

class MyScaffold extends StatelessWidget {
  const MyScaffold(
    this.$, {
    Key? key,
    required this.title,
    required this.body,
    this.menu,
  }) : super(key: key);

  final MyScaffoldContext $;
  final Widget body;
  final Widget title;
  final Widget? menu;

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName: Text('Kasper Peulen'),
              accountEmail: Text('kasperpeulen@gmail.com'),
              currentAccountPicture: CircleAvatar(radius: 30),
            ),
            ListTile(
              title: const Text('Inbox'),
              leading: const Icon(Icons.inbox),
              onTap: () {
                $.events.add(Event.onInboxOpened());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Today'),
              leading: const Icon(Icons.today),
              onTap: () {
                $.events.add(Event.onTodayOpened());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: title,
        actions: [
          if (menu != null) menu!,
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          $.route.revive((it) => it.addModal(CreateTodoModal(form: TodoForm())));
        },
        tooltip: 'Add todo',
        child: Icon(Icons.add),
      ),
    );
  }
}

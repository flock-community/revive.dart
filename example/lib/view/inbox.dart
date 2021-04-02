import 'package:flutter/material.dart';
import 'package:revive_example/view/todo_view.dart';

abstract class InboxContext implements TodoListContext {}

class Inbox extends StatelessWidget {
  Inbox(this.$);

  final InboxContext $;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: TodoList($),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add todo',
        child: Icon(Icons.add),
      ),
    );
  }
}

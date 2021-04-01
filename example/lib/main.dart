import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/view/todo_view.dart';

import 'app.dart';
import 'mock/todo.dart';

void main() {
  final $ = TestContext([todoMock(description: 'Make revive')]);
  $.effects.listen((it) => print('${DateFormat('yyyy-MM-dd hh:mm:ss:SSSS').format(DateTime.now())} ${it}'));
  $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
  $.events.listen((event) => app($, event));

  runApp(View($));
}

abstract class ViewContext implements InboxContext {}

class View extends StatelessWidget {
  View(this.$);

  final ViewContext $;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Inbox($),
    );
  }
}

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

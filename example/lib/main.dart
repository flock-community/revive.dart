import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/view/view.dart';

void main() {
  final $ = TestContext.fromMocks(todos: [todoMock(description: 'Make revive')]);

  // log
  $.effects.listen((it) => print('${DateFormat('yyyy-MM-dd hh:mm:ss:SSSS').format(DateTime.now())} ${it}'));
  // add events as Input Effect
  $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
  // handle events
  $.events.listen((event) => app($, event));

  runApp(View($));
}

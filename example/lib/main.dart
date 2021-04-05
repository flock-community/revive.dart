import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/view/view.dart';
import 'package:kt_dart/kt.dart';

void main() {
  var todosMock = [todoMock(description: 'Make revive')];

  final $ = TestLayer().let(($) => TestContext(
        layer: $,
        todoRepo: TestRepository($, todosMock, getAll: (models) async {
          // override with slower version
          await Future<void>.delayed(Duration(seconds: 1));
          return models;
        }),
      ));

  // log
  $.effects.listen((it) => print('${DateFormat('yyyy-MM-dd hh:mm:ss:SSSS').format(DateTime.now())} ${it}'));
  // add events as Input Effect
  $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
  // handle events
  $.events.listen((event) => app($, event));

  $.events.add(Event.onAppStarted());

  runApp(View($));
}

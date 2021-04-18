import 'package:flutter/material.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/service/clock.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/view/view.dart';

void main() {
  final $ = TestLayer(clock: LiveClock()).let(
    ($) => TestContext(
      layer: $,
      todoRepo: TestRepository(
        $,
        someTodos($),
        delay: () => 750.milliseconds,
      ),
    ),
  );

  // log
  $.effects.listen((it) => print('${it}'));
  // add events as Input Effect
  $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
  // handle events
  $.events.listen((event) => app($, event));

  $.events.add(Event.onAppStarted());

  runApp(View($));
}

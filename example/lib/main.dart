import 'package:flutter/material.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/view/view.dart';
import 'package:kt_dart/kt.dart';
import 'package:revive/model/model.dart';

void main() {
  var layer = TestLayer();
  final $ = layer.let(($) => TestContext(
        layer: $,
        todoRepo: TestRepository(
          $,
          [todoMock($, description: 'Make revive')],
          getAll: (self) async {
            // override with slower version
            await Future<void>.delayed(Duration(seconds: 2));
            return self.models;
          },
          update: (self, model) async {
            await Future<void>.delayed(Duration(seconds: 2));
            self.models = self.models.update(model);
          },
        ),
      ));

  // log
  layer.effects.listen((it) => print('${it}'));
  // add events as Input Effect
  $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
  // handle events
  $.events.listen((event) => app($, event));

  $.events.add(Event.onAppStarted());

  runApp(View($));
}

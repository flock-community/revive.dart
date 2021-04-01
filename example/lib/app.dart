import 'package:revive_example/event/todo_events.dart';

import 'model/event.dart';

abstract class App implements OnTodoCompleted {}

Future<void> app(App $, Event event) {
  return event.map<Future<void>>(
    onTodoCompleted: (event) => onTodoCompleted($, event),
  );
}

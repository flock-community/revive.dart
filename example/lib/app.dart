import 'package:revive_example/event/todo_events.dart';

import 'model/event.dart';

abstract class App implements OnStartApp, OnTodoCompleted, OnInboxOpened, OnTodayOpened {}

Future<void> app(App $, Event event) {
  return event.map<Future<void>>(
    onAppStarted: (event) => onStartApp($, event),
    onTodoCompleted: (event) => onTodoCompleted($, event),
    onInboxOpened: (event) => onInboxOpened($, event),
    onTodayOpened: (event) => onTodayOpened($, event),
  );
}

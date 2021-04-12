import 'package:revive_example/event/todo_events.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/widgets.dart';

import 'model/event.dart';

abstract class App
    implements OnStartApp, OnTodoCompleted, OnInboxOpened, OnTodayOpened, OnCreateTodoFormSubmitted, Messenger {}

Future<void> app(App $, Event event) async {
  try {
    await event.map<Future<void>>(
      onAppStarted: (event) => onStartApp($, event),
      onTodoCompleted: (event) => onTodoCompleted($, event),
      onInboxOpened: (event) => onInboxOpened($, event),
      onTodayOpened: (event) => onTodayOpened($, event),
      onCreateTodoFormSubmitted: (event) => onCreateTodoFormSubmitted($, event),
    );
  } catch (_) {
    $.messenger.showSnackBar(SnackBar(content: Text('Something went wrong. Try again.')));
  }
}

import 'package:revive_example/model/event.dart';
import 'package:rxdart/rxdart.dart';

abstract class EventStream {
  abstract final Subject<Event> events;
}

class LiveEventStream implements EventStream {
  final events = PublishSubject();
}

class TestEventStream implements EventStream {
  final events = PublishSubject();
}

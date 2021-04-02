import 'package:revive_example/model/event.dart';
import 'package:rxdart/rxdart.dart';

abstract class EventStream {
  abstract final Subject<Event> events;
}

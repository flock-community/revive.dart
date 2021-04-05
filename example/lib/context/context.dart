import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/model/async.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/view/view.dart';
import 'package:rxdart/rxdart.dart';

class Context implements ViewContext, App {
  Context({required this.events, required this.todoRepo, required this.todos, required this.route});

  final Subject<Event> events;
  final Repository<Todo> todoRepo;
  final StateSubject<Async<List<Todo>, AsyncException>> todos;
  final StateSubject<Route> route;
}

import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/view/view.dart';
import 'package:rxdart/rxdart.dart';

class Context implements ViewContext, App {
  final Subject<Event> events;
  final Repository<Todo> todoRepo;
  final StateStream<List<Todo>> todos;

  Context({required this.events, required this.todoRepo, required this.todos});
}

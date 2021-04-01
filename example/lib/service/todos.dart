import 'package:revive/effect/effect.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/model/todo.dart';
import 'package:rxdart/rxdart.dart';

abstract class Todos {
  abstract final StateStream<List<Todo>> todos;
}

class LiveTodos implements Todos {
  final StateStream<List<Todo>> todos;

  LiveTodos([List<Todo> todos = const []]) : todos = StateStream(todos);
}

class TestTodos implements Todos {
  final StateStream<List<Todo>> todos;

  TestTodos([List<Todo> todos = const [], Subject<Effect>? effects]) : todos = TestStateStream(todos, effects);
}

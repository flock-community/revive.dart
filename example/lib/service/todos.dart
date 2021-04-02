import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/model/todo.dart';

abstract class Todos {
  abstract final StateStream<List<Todo>> todos;
}

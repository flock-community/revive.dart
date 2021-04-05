import 'package:revive/revive/state_stream.dart';
import 'package:revive/model/async.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive_example/model/todo.dart';

abstract class Todos {
  abstract final StateSubject<Async<List<Todo>, AsyncException>> todos;
}

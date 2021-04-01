import 'package:revive/repository/repository.dart';
import 'package:revive_example/model/todo.dart';

abstract class TodoRepo {
  abstract final Repository<Todo> todoRepo;
}

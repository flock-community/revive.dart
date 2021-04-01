import 'package:revive/repository/repository.dart';
import 'package:revive_example/model/todo.dart';

abstract class TodoRepo {
  abstract final Repository<Todo> todoRepo;
}

class ErrorTodoRepo extends TestRepository<Todo> implements Repository<Todo> {
  ErrorTodoRepo() : super([]);

  Future<void> update(Todo model) async {
    await Future<void>.delayed(Duration(seconds: 2));
    throw Exception();
  }
}

import 'package:revive_example/model/route.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/service/todo_repo.dart';
import 'package:revive_example/service/todos.dart';

abstract class RouteTo implements Todos, TodoRepo, RouteState {}

Future<void> routeTo(RouteTo $, Route route) async {
  $.route.state = route;
  await route.map(
    inbox: (_) async {
      await $.todos.setFromStream($.todos.state.load(() => $.todoRepo.getAll()));
    },
    today: (_) async {
      await $.todos.setFromStream($.todos.state.load(() => $.todoRepo.getAll()));
    },
  );
}

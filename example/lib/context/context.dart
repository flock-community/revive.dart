import 'package:revive/effect/effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/main.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/events.dart';
import 'package:rxdart/rxdart.dart';

class Context implements ViewContext, App {
  final Subject<Event> events;
  final Repository<Todo> todoRepo;
  final StateStream<List<Todo>> todos;

  Context({required this.events, required this.todoRepo, required this.todos});
}

class TestContext with LiveEventStream implements Context {
  Subject<Effect> effects;
  Repository<Todo> todoRepo;
  StateStream<List<Todo>> todos;

  TestContext._({required this.todoRepo, required this.todos, required this.effects});

  factory TestContext([List<Todo> todos = const []]) {
    final effects = PublishSubject<Effect>();
    return TestContext._(
      effects: effects,
      todoRepo: TestRepository(todos, effects),
      todos: TestStateStream(todos, effects),
    );
  }

  TestContext build(TestContext Function(TestContext $) builder) => builder(this);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/todo.dart';
import 'package:rxdart/rxdart.dart';

part 'test_context.freezed.dart';

@freezed
class TestContext with _$TestContext implements Context, TestEffect {
  TestContext._();

  factory TestContext.raw({
    required TestLayer layer,
    required Subject<Event> events,
    required Repository<Todo> todoRepo,
    required StateStream<List<Todo>> todos,
  }) = _TestContext;

  factory TestContext({
    TestLayer? layer,
    Subject<Event>? events,
    Repository<Todo>? todoRepo,
    StateStream<List<Todo>>? todos,
  }) {
    layer = layer ?? TestLayer(effects: PublishSubject());
    return TestContext.raw(
      layer: layer,
      events: events ?? PublishSubject(),
      todoRepo: todoRepo ?? TestRepository(layer, []),
      todos: todos ?? TestStateStream(layer, []),
    );
  }

  factory TestContext.fromMocks({List<Todo> todos = const []}) {
    final layer = TestLayer();
    return TestContext(
      layer: layer,
      todoRepo: TestRepository(layer, todos),
      todos: TestStateStream(layer, todos),
    );
  }

  Subject<Effect> get effects => layer.effects;
}

@freezed
class TestLayer with _$TestLayer implements TestRepositoryContext, TestStateStreamContext {
  factory TestLayer.raw({required Subject<Effect> effects}) = _TestLayer;

  factory TestLayer({Subject<Effect>? effects}) {
    return TestLayer.raw(effects: effects ?? PublishSubject(sync: true));
  }
}

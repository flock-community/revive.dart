import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/model/async.dart';
import 'package:revive/service/clock.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive/service/id_generator.dart';
import 'package:revive_example/widgets.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/model/route.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/navigator.dart';
import 'package:rxdart/rxdart.dart';

part 'test_context.freezed.dart';

@freezed
class TestContext with _$TestContext, FlutterNavigator, FlutterMessenger implements Context, TestEffect {
  TestContext._();

  factory TestContext.raw({
    required Subject<Event> events,
    required Subject<Effect> effects,
    required Repository<Todo> todoRepo,
    required StateSubject<Async<List<Todo>, AsyncException>> todos,
    required StateSubject<Route> route,
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldMessengerState> messengerKey,
    required IdGenerator id,
    required Clock clock,
  }) = _TestContext;

  factory TestContext({
    TestLayer? layer,
    Subject<Event>? events,
    Repository<Todo>? todoRepo,
    StateSubject<Async<List<Todo>, AsyncException>>? todos,
    StateSubject<Route>? route,
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<ScaffoldMessengerState>? messengerKey,
  }) {
    layer = layer ?? TestLayer();
    return TestContext.raw(
      effects: layer.effects,
      events: events ?? PublishSubject(),
      todoRepo: todoRepo ?? TestRepository(layer, []),
      todos: todos ?? TestStateStream(layer, Async.none(NotLoaded(), loading: false)),
      route: route ?? TestStateStream(layer, Route.inbox()),
      navigatorKey: navigatorKey ?? GlobalKey(),
      messengerKey: messengerKey ?? GlobalKey(),
      id: layer.id,
      clock: layer.clock,
    );
  }

  factory TestContext.fromData({List<Todo> todos = const [], Route route = const Route.inbox()}) {
    final layer = TestLayer();
    return TestContext(
      layer: layer,
      todoRepo: TestRepository(layer, todos),
      todos: TestStateStream(layer, Async.done(todos, loading: false)),
      route: TestStateStream(layer, route),
    );
  }
}

@freezed
class TestLayer with _$TestLayer implements TodoMock, TestRepositoryContext, TestStateStreamContext {
  TestLayer._();

  factory TestLayer.raw({
    required Subject<Effect> effects,
    required IdGenerator id,
    required Clock clock,
  }) = _TestLayer;

  factory TestLayer({
    Subject<Effect>? effects,
    IdGenerator? id,
    Clock? clock,
  }) {
    return TestLayer.raw(
      effects: effects ?? PublishSubject(sync: true),
      id: id ?? TestIdGenerator(),
      clock: clock ?? TestClock(DateTime(2020, 1, 1, 12)),
    );
  }
}

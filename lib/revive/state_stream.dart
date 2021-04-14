import 'dart:async';

import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/revive/reviver.dart';

class StateStream<State> extends StreamView<State> {
  StateStream(this.stream, this.state) : super(stream);

  final Stream<State> stream;
  final State state;

  @override
  StateStream<R> map<R>(R convert(State event)) {
    return StateStream(stream.map(convert), convert(state));
  }

  @override
  Future<List<State>> toList() async => [state, ...await stream.toList()];

  @override
  Future<State> get first async => state;

  @override
  StateStream<State> where(bool test(State event)) {
    return StateStream(stream.where(test), state);
  }

  @override
  StateStream<State> distinct([bool equals(State previous, State next)?]) {
    return StateStream(stream.distinct(equals), state);
  }
}

class StateSubject<State> {
  StateSubject(State state, [StreamController<State>? streamController])
      : _state = state,
        controller = streamController ?? StreamController.broadcast(sync: false);

  final StreamController<State> controller;

  StateStream<State> get stream => StateStream(controller.stream, state);

  State _state;

  State get state => _state;

  set state(State state) {
    _state = state;
    controller.add(state);
  }

  Future<void> setFromStream(Stream<State> stream, [bool cancelOnChanged = true]) async {
    var previousState = state;
    await for (var newState in stream) {
      if (cancelOnChanged && !identical(previousState, state)) break;
      state = previousState = newState;
    }
  }

  void revive(Reviver<State> reviver) {
    state = reviver(state);
  }
}

abstract class TestStateStreamContext implements TestEffect {}

class TestStateStream<State> extends StateSubject<State> {
  TestStateStream(this.$, State state, [StreamController<State>? streamController])
      : super(state, streamController ?? StreamController.broadcast(sync: true));

  final TestStateStreamContext $;

  set state(State state) {
    $.effects.add(Output(revive, state, this));
    super.state = state;
  }
}

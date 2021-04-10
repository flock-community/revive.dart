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
  StateStream<State> where(bool test(State event)) {
    return StateStream(stream.where(test), state);
  }

  @override
  StateStream<R> cast<R>() {
    return StateStream(stream.cast<R>(), state as R);
  }

  @override
  StateStream<State> distinct([bool equals(State previous, State next)?]) {
    return StateStream(stream.distinct(equals), state);
  }
}

class StateSubject<State> {
  StateSubject(State state, [StreamController<State>? streamController])
      : _state = state,
        _streamController = streamController ?? StreamController.broadcast(sync: false);

  final StreamController<State> _streamController;

  StateStream<State> get stream => StateStream(_streamController.stream, state);

  State _state;

  State get state => _state;

  set state(State state) {
    _state = state;
    _streamController.add(state);
  }

  Future<void> setFromStream(Stream<State> stream) async {
    await for (var newState in stream) {
      state = newState;
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

import 'dart:async';

import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/revive/reviver.dart';

class StateStream<State> {
  StateStream(State state, [StreamController<State>? streamController])
      : _state = state,
        _streamController = streamController ?? StreamController.broadcast(sync: false);

  final StreamController<State> _streamController;

  Stream<State> get stream => _streamController.stream;

  State _state;

  State get state => _state;

  set state(State state) {
    _state = state;
    _streamController.add(state);
  }

  void revive(Reviver<State> reviver) {
    state = reviver(state);
  }
}

abstract class TestStateStreamContext implements TestEffect {}

class TestStateStream<State> extends StateStream<State> {
  TestStateStream(this.$, State state, [StreamController<State>? streamController])
      : super(state, streamController ?? StreamController.broadcast(sync: true));

  final TestStateStreamContext $;

  set state(State state) {
    $.effects.add(Output(revive, state, this));
    super.state = state;
  }
}

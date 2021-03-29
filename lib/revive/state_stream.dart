import 'dart:async';

import 'package:revive/effect/effect.dart';
import 'package:revive/revive/reviver.dart';
import 'package:rxdart/rxdart.dart';

class StateStream<State> {
  StateStream({required State state})
      : _state = state,
        _streamController = StreamController.broadcast();

  final StreamController<State> _streamController;

  Stream<State> get stream => _streamController.stream;

  State _state;

  State get state => _state;

  set state(State state) {
    _streamController.add(state);
    _state = state;
  }

  void revive(Reviver<State> reviver) {
    state = reviver(state);
  }
}

class TestStateStream<State> extends StateStream<State> {
  TestStateStream({required State state, this.effects}) : super(state: state);

  final Subject<Effect>? effects;

  set state(State state) {
    effects?.add(Output(revive, state, this));
    super.state = state;
  }
}

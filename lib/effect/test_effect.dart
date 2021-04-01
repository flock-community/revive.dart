import 'dart:async';

import 'effect.dart';

abstract class TestEffect {
  abstract final StreamController<Effect>? effects;
}

extension X on TestEffect {
  Future<I> io<I extends Object?, O extends Object?>(
    Function method, {
    required O output,
    required I input,
    Duration duration = const Duration(seconds: 0),
  }) async {
    effects?.add(Output(method, output, this));
    await Future<void>.delayed(duration);
    effects?.add(Input(method, input, this));
    return input;
  }

  Future<I> input<I extends Object?>(Function method, I input) async {
    effects?.add(Input(method, input, this));
    return input;
  }

  Future<void> output<I extends Object?>(Function method, I output) async {
    return effects?.add(Output(method, output, this));
  }
}

extension StreamEffectX on Stream<Effect> {
  Future<List<Effect>> collect(Future<void> Function() future) {
    return collectEffects(this, future);
  }
}

Future<List<Effect>> collectEffects(Stream<Effect> effectStream, Future<void> Function() future) async {
  List<Effect> effects = [];
  var sub = effectStream.listen((value) => effects.add(value));
  await future();
  await Future<void>.value();
  await Future<void>.value();
  await sub.cancel();
  return effects;
}

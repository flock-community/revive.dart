import 'dart:async';

import 'effect.dart';

abstract class TestEffect {
  abstract final StreamController<Effect> effects;
}

extension XTestEffect on TestEffect {
  Future<I> io<I extends Object?, O extends Object?>(
    Function method, {
    required O output,
    required I input,
    Duration? duration,
  }) async {
    effects.add(Output(method, output, this));
    if (duration != null) await Future<void>.delayed(duration);
    effects.add(Input(method, input, this));
    return input;
  }

  Future<I> input<I extends Object?>(Function method, I input) async {
    effects.add(Input(method, input, this));
    return input;
  }

  Future<void> output<I extends Object?>(Function method, I output) async {
    return effects.add(Output(method, output, this));
  }

  Future<List<Effect>> collectEffects(Future<void> Function() callback) async {
    List<Effect> collected = [];
    var sub = this.effects.stream.listen(collected.add);
    await callback();
    sub.cancel(); // ignore: unawaited_futures
    return collected;
  }
}

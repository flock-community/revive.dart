import 'dart:ui';

import 'package:revive/utils/function.dart';

abstract class Effect {}

class Input implements Effect {
  const Input(this.method, [this.input, this.object]);

  final Function method;
  final Object? input;
  final Object? object;

  bool operator ==(dynamic other) =>
      this == other || (other is Input && method == other.method && input == other.input);

  int get hashCode => hashValues(method, input);

  String toString() => '[Input]  ${'${object == null ? '' : '${object.runtimeType}.'}${method.name}'}${'() => $input'}';
}

class Output implements Effect {
  const Output(this.method, [this.output, this.object]);

  final Function method;
  final Object? output;
  final Object? object;

  bool operator ==(dynamic other) =>
      this == other || (other is Output && method == other.method && output == other.output);

  int get hashCode => hashValues(method, output);

  String toString() =>
      '[Output] ${'${object == null ? '' : '${object.runtimeType}.'}${method.name}'}${'(${output ?? ''})'}';
}

import 'package:collection/collection.dart';
import 'package:revive/utils/function.dart';

abstract class Effect {
  abstract final Function method;
}

class Input implements Effect {
  const Input(this.method, [this.input, this.object]);

  final Function method;
  final Object? input;
  final Object? object;

  bool operator ==(dynamic other) => (other is Input &&
      method == other.method &&
      (identical(other.input, input) || const DeepCollectionEquality().equals(other.input, input)));

  int get hashCode => const DeepCollectionEquality().hash(method) ^ const DeepCollectionEquality().hash(input);

  String toString() => '[Input]  ${'${object == null ? '' : '${object.runtimeType}.'}${method.name}'}${'() => $input'}';
}

class Output implements Effect {
  const Output(this.method, [this.output, this.object]);

  final Function method;
  final Object? output;
  final Object? object;

  bool operator ==(dynamic other) {
    return (other is Output &&
        method == other.method &&
        (identical(other.output, output) || const DeepCollectionEquality().equals(other.output, output)));
  }

  int get hashCode => const DeepCollectionEquality().hash(method) ^ const DeepCollectionEquality().hash(output);

  String toString() =>
      '[Output] ${'${object == null ? '' : '${object.runtimeType}.'}${method.name}'}${'(${output ?? ''})'}';
}

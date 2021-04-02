import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/state_stream.dart';

T useStateStream<T>(StateStream<T> stateStream, [Stream<T>? stream]) {
  final result = useState<T>(stateStream.state);
  useEffect(() => (stream ?? stateStream.stream).listen((it) => result.value = it).cancel, []);
  return result.value;
}

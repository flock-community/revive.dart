import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/state_stream.dart';

T useStateStream<T>(StateStream<T> stateStream, [Stream<T>? stream]) {
  final _stream = stream ?? stateStream.stream;
  final result = useState<T>(stateStream.state);
  useEffect(() {
    final subscription = _stream.listen((it) => result.value = it);
    return subscription.cancel;
  }, []);
  return result.value;
}

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/state_stream.dart';

T useStateStream<T>(StateStream<T> stateStream, dynamic deps) {
  final result = useState<T>(stateStream.state);
  useEffect(() => stateStream.listen((it) => result.value = it).cancel, [deps]);
  return result.value;
}

import 'package:revive_example/widgets.dart';

abstract class Messenger {
  abstract final GlobalKey<ScaffoldMessengerState> messengerKey;
  abstract final ScaffoldMessengerState messenger;
}

mixin FlutterMessenger {
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey();
  ScaffoldMessengerState get messenger => messengerKey.currentState!;
}

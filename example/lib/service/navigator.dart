import 'package:revive_example/widgets.dart';

abstract class WithNavigator {
  abstract final GlobalKey<NavigatorState> navigatorKey;
  abstract final NavigatorState navigator;
}

mixin FlutterNavigator implements WithNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  NavigatorState get navigator => navigatorKey.currentState!;
}

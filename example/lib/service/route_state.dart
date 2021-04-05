import 'package:revive/revive/state_stream.dart';
import 'package:revive_example/model/route.dart';

abstract class RouteState {
  abstract final StateSubject<Route> route;
}

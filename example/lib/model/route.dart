import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class Route with _$Route {
  factory Route.inbox() = Inbox;
  factory Route.today() = Today;

  factory Route.fromJson(Map<String, Object> json) => _$RouteFromJson(json);
}

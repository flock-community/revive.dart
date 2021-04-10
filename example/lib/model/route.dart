import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';

part 'route.g.dart';

@freezed
class Route with _$Route {
  factory Route.inbox([Modal? modal]) = Inbox;
  factory Route.today([Modal? modal]) = Today;
  factory Route.fromJson(Map<String, Object> json) => _$RouteFromJson(json);

  Route._();

  Route removeModal() => this.copyWith(modal: null);
  Route addModal(Modal modal) => this.copyWith(modal: modal);
  Route updateModal(Modal modal) => this.copyWith(modal: modal);
}

@freezed
class Modal with _$Modal {
  factory Modal.createTodo({@Default(false) bool submitting}) = CreateTodoForm;

  factory Modal.fromJson(Map<String, Object> json) => _$ModalFromJson(json);
}

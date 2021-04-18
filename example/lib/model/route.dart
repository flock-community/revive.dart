import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_example/model/todo.dart';
import 'package:revive_example/model/todo_form.dart';

part 'route.freezed.dart';

part 'route.g.dart';

@freezed
class Route with _$Route {
  const Route._();
  const factory Route.inbox({Modal? modal, @Default(false) bool showCompleted}) = Inbox;
  const factory Route.today({Modal? modal, @Default(false) bool showCompleted}) = Today;
  factory Route.fromJson(Map<String, Object> json) => _$RouteFromJson(json);

  Route removeModal() => this.copyWith(modal: null);
  Route addModal(Modal modal) => this.copyWith(modal: modal);
  Route updateModal(Modal modal) => this.copyWith(modal: modal);
}

@freezed
class Modal with _$Modal {
  const factory Modal.createTodo({required TodoForm form}) = CreateTodoModal;
  const factory Modal.updateTodo({required TodoForm form, required Todo todo}) = UpdateTodoModal;

  factory Modal.fromJson(Map<String, Object> json) => _$ModalFromJson(json);
}

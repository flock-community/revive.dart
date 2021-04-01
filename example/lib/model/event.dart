import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive_example/model/todo.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  factory Event.onTodoCompleted(Todo todo) = TodoCompleted;

  factory Event.fromJson(Map<String, Object> json) => _$EventFromJson(json);
}

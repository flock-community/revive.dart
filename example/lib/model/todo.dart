import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo implements Model {
  const factory Todo({
    required String id,
    required String description,
    required bool completed,
    DateTime? dueDate,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';

part 'model_test.freezed.dart';

@freezed
class Todo with _$Todo implements Model {
  const factory Todo(String id, String body) = _Todo;
}

void main() {
  group('Model', () {
    const todo = Todo('0', 'todo');
    test('create', () {
      expect(<Todo>[].create(todo), [todo]);
    });

    test('update', () {
      expect([todo].update(todo.copyWith(body: 'changed')), [Todo('0', 'changed')]);
    });

    test('delete', () {
      expect([todo].delete('0'), <Todo>[]);
    });
  });
}

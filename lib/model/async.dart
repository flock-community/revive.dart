import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';

part 'async.freezed.dart';

@freezed
class Async<T, E extends Object> with _$Async<T, E> {
  Async._();

  factory Async.none(E error, {required bool loading}) = None;

  factory Async.done(T data, {E? error, required bool loading}) = Done;

  Done<T, E> assertDone() {
    return this.map(
      done: (it) => it,
      none: (it) => throw it.error,
    );
  }

  Stream<Async<T, E>> load(Future<T> Function() future) async* {
    yield this.copyWith(loading: true);
    try {
      yield Done(await future(), loading: false);
    } on E catch (e) {
      yield this.map(
        done: (it) => it.copyWith(error: e, loading: false),
        none: (it) => it.copyWith(error: e, loading: false),
      );
    } catch (e) {
      yield this.copyWith(loading: false);
    }
  }
}

extension AsyncList<T extends Model, E extends Object> on Async<List<T>, E> {
  Done<List<T>, E> create(T model) {
    var done = assertDone();
    return done.copyWith(data: done.data.create(model));
  }

  Done<List<T>, E> update(T model) {
    var done = assertDone();
    return done.copyWith(data: done.data.update(model));
  }

  Done<List<T>, E> delete(String id) {
    var done = assertDone();
    return done.copyWith(data: done.data.delete(id));
  }
}

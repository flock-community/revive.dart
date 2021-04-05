import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:revive/model/model.dart';
import 'package:revive/revive/reviver.dart';

part 'async.freezed.dart';

@freezed
class Async<T, E extends Object> with _$Async<T, E> {
  factory Async.none(E error, {@Default(false) bool loading}) = None;

  factory Async.done(T data, {E? error, @Default(false) bool loading}) = Done;

  Async._();

  Done<T, E> assertDone() {
    return this.map(
      done: (it) => it,
      none: (it) => throw it.error,
    );
  }

  Stream<Async<T, E>> update(Future<T> Function() future) async* {
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

extension ObjectX<T> on T {
  Done<T, E> done<E extends Object>() => Done<T, E>(this);
}

Reviver<Async<List<T>, E>> create<T extends Model, E extends Object>(T model) => (state) {
      return state.map(
        done: (it) => it.copyWith(data: it.data.create(model)),
        none: (it) => throw it.error,
      );
    };

Reviver<Async<List<T>, E>> update<T extends Model, E extends Object>(T model) => (state) {
      return state.map(
        done: (it) => it.copyWith(data: it.data.update(model)),
        none: (it) => throw it.error,
      );
    };

Reviver<Async<List<T>, E>> delete<T extends Model, E extends Object>(String id) => (state) {
      return state.map(
        done: (it) => it.copyWith(data: it.data.delete(id)),
        none: (it) => throw it.error,
      );
    };

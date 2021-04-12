import 'dart:async';

import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/model/model.dart';
import 'package:revive/service/clock.dart';

abstract class Repository<T extends Model> {
  Future<T?> get(String id);

  Future<List<T>> getAll();

  Future<void> create(T model);

  Future<void> update(T model);

  Future<void> delete(String id);
}

abstract class TestRepositoryContext implements TestEffect, WithClock {}

class TestRepository<T extends Model> implements Repository<T>, TestEffect {
  TestRepository(
    this.$,
    this.models, {
    this.delay,
    Future<T?> Function(TestRepository<T> self, String id)? get,
    Future<List<T>> Function(TestRepository<T> self)? getAll,
    Future<void> Function(TestRepository<T> self, T model)? create,
    Future<void> Function(TestRepository<T> self, T model)? update,
    Future<void> Function(TestRepository<T> self, String id)? delete,
    this.createFn,
  })  : _get = get ?? ((self, id) async => self.models.get(id)),
        _getAll = getAll ?? ((self) async => self.models),
        _create = create ?? ((self, model) async => self.models = self.models.create(model)),
        _update = update ?? ((self, model) async => self.models = self.models.update(model)),
        _delete = delete ?? ((self, id) async => self.models = self.models.delete(id));

  final TestRepositoryContext $;

  StreamController<Effect> get effects => $.effects;

  Duration Function()? delay;
  List<T> models;
  Future<T?> Function(TestRepository<T> self, String id) _get;
  Future<List<T>> Function(TestRepository<T> self) _getAll;
  Future<void> Function(TestRepository<T> self, T model) _create;
  Future<void> Function(TestRepository<T> self, T model) _update;
  Future<void> Function(TestRepository<T> self, String id) _delete;

  get(String id) async => input(get, await _get(this, id));

  getAll() async {
    await _delay();
    return $.input(getAll, await _getAll(this));
  }

  Future<void> Function(List<T>, T)? createFn;

  create(T model) async {
    await output(create, model);
    await _delay();
    await _create(this, model);
  }

  update(T model) async {
    await output(update, model);
    await _delay();
    await _update(this, model);
  }

  delete(String id) async {
    await output(delete, id);
    await _delay();
    await _delete(this, id);
  }

  Future<void> _delay() async {
    var sleep = delay?.call();
    if (sleep != null) await $.clock.sleep(sleep);
  }
}

import 'dart:async';

import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/model/model.dart';

abstract class Repository<T extends Model> {
  Future<T?> get(String id);

  Future<List<T>> getAll();

  Future<void> create(T model);

  Future<void> update(T model);

  Future<void> delete(String id);
}

abstract class TestRepositoryContext implements TestEffect {}

class TestRepository<T extends Model> implements Repository<T>, TestEffect {
  TestRepository(
    this.$,
    this.models, {
    Future<T?> Function(List<T> models, String id)? get,
    Future<List<T>> Function(List<T> models)? getAll,
    Future<void> Function(List<T> models, T model)? create,
    Future<void> Function(List<T> models, T model)? update,
    Future<void> Function(List<T> models, String id)? delete,
    this.createFn,
  })  : _get = get ?? ((models, id) async => models.get(id)),
        _getAll = getAll ?? ((models) async => models),
        _create = create ?? ((models, model) async => models = models.create(model)),
        _update = update ?? ((models, model) async => models = models.update(model)),
        _delete = delete ?? ((models, id) async => models = models.delete(id));

  final TestRepositoryContext $;

  StreamController<Effect> get effects => $.effects;

  List<T> models;
  Future<T?> Function(List<T> models, String id) _get;
  Future<List<T>> Function(List<T> models) _getAll;
  Future<void> Function(List<T> models, T model) _create;
  Future<void> Function(List<T> models, T model) _update;
  Future<void> Function(List<T> models, String id) _delete;

  get(String id) async => input(get, await _get(models, id));

  getAll() async {
    return $.input(getAll, await _getAll(models));
  }

  Future<void> Function(List<T>, T)? createFn;

  create(T model) async {
    await output(create, model);
    await _create(models, model);
  }

  update(T model) async {
    await output(update, model);
    await _update(models, model);
  }

  delete(String id) async {
    await output(delete, id);
    await _delete(models, id);
  }
}

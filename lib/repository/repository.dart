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

class TestRepository<T extends Model> implements Repository<T>, TestEffect {
  TestRepository(this.models, [this.effects]);

  final StreamController<Effect>? effects;
  List<T> models;

  get(String id) => input(get, models.get(id));

  getAll() => input(getAll, this.models);

  create(T model) async {
    models = models.create(model);
    await output(create, model);
  }

  update(T model) async {
    models = models.update(model);
    await output(update, model);
  }

  delete(String id) async {
    models = models.delete(id);
    await output(delete, id);
  }
}

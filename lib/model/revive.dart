import 'package:revive/model/model.dart';
import 'package:revive/revive/reviver.dart';

Reviver<List<T>> create<T extends Model>(T model) => (state) => state.create(model);

Reviver<List<T>> update<T extends Model>(T model) => (state) => state.update(model);

Reviver<List<T>> delete<T extends Model>(String id) => (state) => state.delete(id);

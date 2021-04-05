abstract class Model {
  abstract final String id;
}

extension X<T extends Model> on Iterable<T> {
  T? get(String id) => firstWhere((it) => it.id == id);

  List<T> create(T model) => [...this, model];

  List<T> update(T model) => [
        for (var it in this)
          if (it.id == model.id) model else it
      ];

  List<T> delete(String id) => [
        for (var it in this)
          if (it.id != id) it
      ];
}

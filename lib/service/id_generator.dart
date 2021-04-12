abstract class WithIdGenerator {
  abstract final IdGenerator id;
}

abstract class IdGenerator {
  String generate();
}

class TestIdGenerator implements IdGenerator {
  final Iterator<String> _iterator = naturals().map((it) => '${it}').iterator;

  String generate() {
    _iterator.moveNext();
    return _iterator.current;
  }
}

Iterable<int> naturals() sync* {
  for (var n = 0;; n = n + 1) {
    yield n;
  }
}

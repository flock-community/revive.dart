abstract class WithClock {
  abstract final Clock clock;
}

abstract class Clock {
  DateTime now();

  Future<void> sleep(Duration duration);
}

class LiveClock implements Clock {
  LiveClock();
  now() => DateTime.now();

  Future<void> sleep(Duration duration) async {
    await Future<void>.delayed(duration);
  }
}

class TestClock implements Clock {
  TestClock(DateTime now) : this._now = now;

  DateTime _now;

  now() => _now;

  Future<void> sleep(Duration duration) async {}

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive/service/clock.dart';
import 'package:revive/service/id_generator.dart';
import 'package:revive/story/story.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/context.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/view/view.dart';
import 'package:revive_example/widgets.dart';
import 'package:rxdart/subjects.dart';

void main() {
  runApp(StoryBook());
}

var storyLayer = StoryBookLayer.raw(
  effects: PublishSubject(sync: true),
  id: TestIdGenerator(),
  clock: StateSubject(LiveClock()),
);

final story = Story<TestContext, StoryBookLayer>(
  name: 'Backend Delay',
  createLayer: () => storyLayer,
  useContext: ($) {
    var clock = useStateStream($.clock.stream, [$]);
    return TestLayer(clock: clock).let(
      ($) => TestContext(
        layer: $,
        todoRepo: TestRepository(
          $,
          someTodos($),
          delay: () => 100.milliseconds,
        ),
      ),
    );
  },
  createWidget: ($) {
    $.effects.listen((it) => print('${it}'));
    // // add events as Input Effect
    $.events.listen((event) => $.effects.add(Input($.events.listen, event, $.events)));
    // // handle events
    $.events.listen((event) => app($, event));
    //

    return View($);
  },
);

class StoryBook extends HookWidget {
  StoryBook();

  Widget build(BuildContext context) {
    var $$ = storyLayer;
    var clock = useStateStream($$.clock.stream, [$$]);

    return MaterialApp(
      // navigatorKey: $.navigatorKey,
      // scaffoldMessengerKey: $.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      color: Colors.blue,
      builder: (_, __) {
        return Stack(
          children: [
            Viiew($$),
            Column(
              children: [
                SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () {
                    $$.clock.revive((state) => TestClock(DateTime(2020, 1, 2, 15)));
                  },
                  child: Text('adsf'),
                ),
                Center(
                  child: Text(
                    'asd',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Viiew extends HookWidget {
  const Viiew(
    this.$$, {
    Key? key,
  }) : super(key: key);

  final StoryBookLayer $$;

  @override
  Widget build(BuildContext context) {
    var clock = useStateStream($$.clock.stream, [$$]);

    var $ = TestLayer(clock: clock).let(
      ($) => TestContext(
        layer: $,
        todoRepo: TestRepository(
          $,
          someTodos($),
          delay: () => 4000.milliseconds,
        ),
      ),
    );

    useEffect(() {
      var sub = $.events.listen((event) => app($, event));
      var sub2 = $.events.listen((event) => print(event));

      $.events.add(Event.onAppStarted());

      return () {
        sub.cancel();
        sub2.cancel();
      };
    }, [$]);

    return View($);
  }
}

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/effect/effect.dart';
import 'package:revive/effect/test_effect.dart';
import 'package:revive/repository/repository.dart';
import 'package:revive/revive/state_stream.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive/service/clock.dart';
import 'package:revive/utils/function.dart';
import 'package:revive_example/app.dart';
import 'package:revive_example/context/test_context.dart';
import 'package:revive_example/mock/todo.dart';
import 'package:revive_example/model/event.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/navigator.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/util/extensions.dart';
import 'package:revive_example/view/inbox_view.dart';
import 'package:revive_example/view/today_view.dart';
import 'package:revive_example/view/todo_form.dart';
import 'package:revive_example/widgets.dart';

abstract class ViewContext implements Messenger, InboxContext, TodayContext, RouteState, WithNavigator {}

class View extends HookWidget {
  const View(this.$);

  final ViewContext $;

  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: $.navigatorKey,
      scaffoldMessengerKey: $.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigator(
        pages: [
          MaterialPage<void>(
            key: ValueKey(route.runtimeType),
            child: route.when(
              inbox: (_) => InboxPage($),
              today: (_) => TodayPage($),
            ),
          ),
          if (modal != null)
            MaterialPage<void>(
              key: ValueKey(modal.runtimeType),
              maintainState: false,
              child: modal.map(
                createTodo: (it) => CreateTodoPage($, it),
                updateTodo: (it) => UpdateTodoPage($, it),
              ),
            )
        ],
        onPopPage: (route, Object? result) {
          if (!route.didPop(result)) return false;
          $.route.revive((it) => it.removeModal());
          return true;
        },
      ),
    );
  }
}

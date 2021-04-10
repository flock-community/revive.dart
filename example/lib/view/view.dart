import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/service/messenger.dart';
import 'package:revive_example/service/navigator.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/view/create_todo.dart';
import 'package:revive_example/view/inbox_view.dart';
import 'package:revive_example/view/today_view.dart';
import 'package:revive_example/widgets.dart';

abstract class ViewContext implements Messenger, InboxContext, TodayContext, RouteState, WithNavigator {}

class View extends HookWidget {
  const View(this.$);

  final ViewContext $;

  Widget build(BuildContext context) {
    final route = useStateStream($.route.stream);
    final modal = route.modal;

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
              inbox: (_) => InboxView($),
              today: (_) => TodayView($),
            ),
          ),
          if (modal != null)
            MaterialPage<void>(
              key: ValueKey(modal.runtimeType),
              maintainState: false,
              child: modal.map(
                createTodo: (it) => CreateTodo($, it),
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

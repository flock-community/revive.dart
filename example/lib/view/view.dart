import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:revive/revive/use_state_stream.dart';
import 'package:revive_example/service/route_state.dart';
import 'package:revive_example/view/inbox_view.dart';
import 'package:revive_example/view/today_view.dart';

abstract class ViewContext implements InboxContext, TodayContext, RouteState {}

class View extends HookWidget {
  View(this.$);

  final ViewContext $;

  Widget build(BuildContext context) {
    final route = useStateStream($.route.stream);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: route.when(
        inbox: () => InboxView($),
        today: () => TodayView($),
      ),
    );
  }
}

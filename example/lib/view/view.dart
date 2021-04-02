import 'package:flutter/material.dart';
import 'package:revive_example/view/inbox.dart';

abstract class ViewContext implements InboxContext {}

class View extends StatelessWidget {
  View(this.$);

  final ViewContext $;

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Inbox($),
    );
  }
}

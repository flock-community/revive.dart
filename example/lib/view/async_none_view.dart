import 'package:flutter/material.dart';
import 'package:revive_example/model/async.dart';
import 'package:revive_example/model/async_exception.dart';

class AsyncNoneView extends StatelessWidget {
  const AsyncNoneView(
    this.asyncNone, {
    Key? key,
  }) : super(key: key);

  final None<Object?, AsyncException> asyncNone;

  @override
  Widget build(BuildContext context) {
    if (asyncNone.loading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return asyncNone.error.map(
        notLoaded: (_) => Center(child: Text('Not loaded')),
        noConnection: (_) => Center(child: Text('No connection')),
      );
    }
  }
}

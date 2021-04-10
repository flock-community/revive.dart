import 'package:revive/model/async.dart';
import 'package:revive_example/model/async_exception.dart';
import 'package:revive_example/widgets.dart';

class AsyncNoneView extends StatelessWidget {
  const AsyncNoneView(
    this.asyncNone, {
    Key? key,
  }) : super(key: key);

  final None<Object?, AsyncException> asyncNone;

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

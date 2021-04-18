import 'package:flutter/widgets.dart';
import 'package:revive/revive/state_stream.dart';

class Story<Context, Layer> {
  Story({
    required this.name,
    required this.useContext,
    required this.createWidget,
    required this.createLayer,
  });

  final String name;
  final Layer Function() createLayer;
  final Context Function(Layer layer) useContext;
  final Widget Function(Context context) createWidget;
}

import 'package:flutter/material.dart';
import 'package:todo_flutter_app/app.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
  initStore();

  runApp(new FlutterReduxApp(
    store: store,
  ));
}

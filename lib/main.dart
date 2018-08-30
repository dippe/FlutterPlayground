import 'package:flutter/material.dart';
import 'package:todo_flutter_app/app.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
  try {
    initStore();

    runApp(new FlutterReduxApp(
      store: store,
    ));
  } catch (e) {
    print('--------------- UNHANDLED EXCEPTION: **** ' + e.toString());
    rethrow;
  }
}

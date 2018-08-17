import 'package:flutter/material.dart';
import 'package:todo_flutter_app/app.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
  runApp(new FlutterReduxApp(
    store: store,
  ));
}

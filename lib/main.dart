import 'package:flutter/material.dart';
import 'package:todo_flutter_app/app.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
  _initFirstTab();

  runApp(new FlutterReduxApp(
    store: store,
  ));
}

_initFirstTab() {
  final idx = store.state.view.actListIdx;
  final filter = store.state.view.issueListViews[idx].filter;

  if (filter != null) {
    JiraAjax.doFetchJqlAction(filter);
  }
}

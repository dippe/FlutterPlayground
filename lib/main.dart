import 'package:flutter/material.dart';
import 'package:todo_flutter_app/App.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
//  fetchIssue('TEST-1', (issue) => print('********* ' + issue.key));
  JiraAjax.doFetchJqlAction('project=test');

  runApp(new FlutterReduxApp(
    store: store,
  ));
}

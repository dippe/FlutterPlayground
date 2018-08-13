import 'package:flutter/material.dart';
import 'package:todo_flutter_app/app.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/state/state.dart';

void main() {
  // fixme: remove these ajax tests
  //  fetchIssue('TEST-1', (issue) => print('********* ' + issue.key));
  JiraAjax.doFetchJqlAction(JiraFilter(jql: 'project=test', id: '0'));

  runApp(new FlutterReduxApp(
    store: store,
  ));
}

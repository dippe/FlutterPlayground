import 'dart:async';

import 'package:http/http.dart';
import 'package:todo_flutter_app/jira/action.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_rest_client.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/util/auth.dart';

class JiraAjax {
  static Future<Response> _jiraGet(String path) {
    // fixme: rethink this direct store access hack
    final user = store.state.config.user;
    final password = store.state.config.password;
    final baseUrl = store.state.config.baseUrl;
    final fullUrl = baseUrl + path;

    print('*** JIRA get request: ' + fullUrl);
    return BasicAuthClient(user, password).get(fullUrl);
  }

  static void doFetchJqlAction(JiraFilter filter) {
    store.dispatch(FetchJqlStart(filter));

    JiraRestClient.fetchIssuesByJql(filter)
        .then((res) => store.dispatch(FetchJqlDone(res, filter)))
        .catchError((error) => store.dispatch(FetchJqlError(error.toString(), filter)));
  }

  static void doFetchIssueAction(String key) {
    store.dispatch(FetchIssueStart());

    JiraRestClient.fetchIssue(key)
        .then((res) => store.dispatch(FetchIssueDone(res)))
        .catchError((error) => store.dispatch(FetchIssueError(error.toString())));
  }

  static void doFetchComponentsAction(String idOrKey) {
    store.dispatch(FetchComponentsStart());

    JiraRestClient.fetchComponents(idOrKey)
        .then((res) => store.dispatch(FetchComponentsDone(res)))
        .catchError((error) => store.dispatch(FetchComponentsError(error.toString())));
  }

  static void doFetchVersionsAction(String idOrKey) {
    store.dispatch(FetchVersionsStart());

    JiraRestClient.fetchVersions(idOrKey)
        .then((res) => store.dispatch(FetchVersionsDone(res)))
        .catchError((error) => store.dispatch(FetchVersionsError(error.toString())));
  }
}

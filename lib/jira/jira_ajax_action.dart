import 'package:todo_flutter_app/jira/action.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_rest_client.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/messages/action.dart';

class _AjaxError {
  static const LIMIT_REACHED = 'Cannot get all of the issues because the MaxResults limit is reached ';
  static const EMPTY_JQL_RESULT = 'Empty JQL result';
}

class JiraAjax {
  static void doFetchJqlAction(JiraFilter filter) {
    store.dispatch(FetchJqlStart(filter));

    JiraRestClient.fetchIssuesByJql(filter).then((res) => _validateJqlMaxResult(res)).then((res) {
      store.dispatch(AddInfoMessageAction('JQL fetch finished successfully'));
      return res;
    }).catchError((err) {
      if (err is ValidationException) {
        store.dispatch(AddWarningMessageAction('Validation Error: ' + err.message + ' \n Filter: ' + filter.name));
      } else {
        store.dispatch(AddErrorMessageAction(err.message + ' \n Filter: ' + filter.name));
      }
      throw Exception('AJAX ERROR: ' + err.toString());
    }).then((res) => store.dispatch(FetchJqlDone(res, filter)));
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

  static _validateJqlMaxResult(res) {
    if (res.total > MAX_RESULTS || res.total > res.maxResults) {
      throw new ValidationException(_AjaxError.LIMIT_REACHED + MAX_RESULTS.toString());
    } else if (res.total == 0) {
      throw new ValidationException(_AjaxError.EMPTY_JQL_RESULT);
    } else {
      return res;
    }
  }
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() {
    return message;
  }
}

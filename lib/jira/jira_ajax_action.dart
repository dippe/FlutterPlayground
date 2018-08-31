import 'dart:async';

import 'package:todo_flutter_app/jira/action.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/jira/jira_rest_client.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/messages/action.dart';

class _AjaxError {
  static const LIMIT_REACHED = 'Cannot get all of the issues because the MaxResults limit is reached ';
  static const EMPTY_JQL_RESULT = 'Empty JQL result';
}

class JiraAjax {
  static Future doFetchJqlAction(JiraFilter filter) {
    final allowedMax = store.state.config.maxJqlIssueNum;
    store.dispatch(FetchJqlStart(filter));

    return JiraRestClient.fetchIssuesByJql(filter, allowedMax)
        .then((res) => _validateJqlMaxResult(res, allowedMax))
        .then((res) {
      store.dispatch(AddInfoMessageAction('JQL fetch finished successfully'));
      return res;
    }).catchError((err) {
      if (err is ValidationException) {
        store.dispatch(AddWarningMessageAction(err.message +
            ' \n Filter: ' +
            filter.name +
            '\n (Validation Exception)'
            ''));
        return err.result;
      } else {
        store.dispatch(AddErrorMessageAction(err.message + ' \n Filter: ' + filter.name));
        store.dispatch(FetchJqlError(
            JiraError(errors: {}, errorMessages: [err is Exception ? (err as dynamic).message : err.toString()]),
            filter));
        throw Exception('AJAX ERROR: ' + err.toString());
      }
    }).then((res) => store.dispatch(FetchJqlDone(res, filter)));
  }

  static void doSearchAction(String text) {
    store.dispatch(SearchStartAction());

    final keyRegexp = RegExp("([a-zA-Z0-9]{1,15}-[0-9]+)");

    final jqlPrefix = keyRegexp.hasMatch(text) ? 'issuekey=\'$text\' or ' : '';

    final filter = JiraFilter(jql: jqlPrefix + 'Text ~ \'$text\'', name: 'Search');

    final allowedMax = store.state.config.maxJqlIssueNum;

    JiraRestClient.fetchIssuesByJql(filter, allowedMax)
        .then((res) => _validateJqlMaxResult(res, allowedMax))
        .then((res) {
      store.dispatch(AddInfoMessageAction('JQL fetch finished successfully'));
      return res;
    }).catchError((err) {
      if (err is ValidationException) {
        final msg = 'Validation Error: ' + err.message + ' \n Filter: ' + filter.name;

        store.dispatch(AddWarningMessageAction(msg));
        return err.result;
      } else {
        store.dispatch(AddErrorMessageAction(err.message + ' \n Filter: ' + filter.name));
        throw Exception('AJAX ERROR: ' + err.toString());
      }
    }).then((res) => store.dispatch(FetchSearchDone(res)));
  }

  static void doFetchFilters() {
//    store.dispatch(FetchFilters());

    JiraRestClient.fetchFavouriteFilters()
        .then((res) => store.dispatch(FetchFiltersDone(res.filters)))
        .catchError((error) => store.dispatch(FetchIssueError(error.toString())));
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

  static _validateJqlMaxResult(res, allowedMax) {
    if (res.total > allowedMax || res.total > res.maxResults) {
      throw new ValidationException(_AjaxError.LIMIT_REACHED + allowedMax.toString(), res);
//    } else if (res.total == 0) {
//      throw new ValidationException(_AjaxError.EMPTY_JQL_RESULT, res);
    } else {
      return res;
    }
  }
}

class ValidationException implements Exception {
  final result;
  final String message;
  ValidationException(this.message, this.result);

  @override
  String toString() {
    return message;
  }
}

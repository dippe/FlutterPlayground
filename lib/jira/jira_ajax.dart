import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_flutter_app/jira/action.dart';
import 'package:todo_flutter_app/jira/domain/error.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/util/auth.dart';

//const TMP_USER = "dippenexus@gmail.com";
//const TMP_PWD = "KGRCC7h58fgfwKO3ZjKN62C9";
//const TMP_BASE_URL = "https://testdev1.atlassian.net";

//const TMP_USER = "gyula_pal";
//const TMP_PWD = "";
//const TMP_BASE_URL = "https://jira.epam.com/jira";

const TMP_USER = "peter_dajka";
const TMP_PWD = "Teflontal432";
const TMP_BASE_URL = "https://jira.epam.com/jira";

const URL_ISSUE = "/rest/api/2/issue/";
const URL_JQL = "/rest/api/2/search";

const MAX_RESULTS = 1000;
const FIELDS_TO_GET = "*all";
//const FIELDS_TO_GET = "status,summary,components,fixVersions,project,issuelinks,issuetype,priority";

class AjaxError {
  static const LIMIT_REACHED = 'Cannot get all of the issues because the MaxResults limit is reached ';
  static const EMPTY_JQL_RESULT = 'Empty JQL result';
}

typedef void GetIssueCb(JiraIssue issue);
typedef void GetJqlCb(JiraSearch res);

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

  static void doFetchJqlAction(JiraFilter filter) => JiraAjax._fetchIssuesByJql(filter).then((res) {
        store.dispatch(FetchJqlDone(res, filter));
      }).catchError((error) {
        store.dispatch(FetchError(error.toString()));
      });

  static void doFetchIssueAction(String baseUrl, String key) => JiraAjax._fetchIssue(key).then((res) {
        store.dispatch(FetchIssueDone(res));
      }).catchError((error) {
        store.dispatch(FetchError(error.toString()));
      });

  static Future<JiraIssue> _fetchIssue(String key) {
    return _jiraGet(URL_ISSUE + key).then((Response val) {
      print(val.body);

      Map issueMap = json.decode(val.body);

      var issue = JiraIssue.fromJson(issueMap);

      print('Issue processed: ' + issue.key);
      return issue;
    });
//        .catchError((err) => print('*** ERROR: ' + err.toString()));
  }

  static Future<JiraSearch> _fetchIssuesByJql(JiraFilter filter) {
    // fixme: re-enable encoding
    //  String ncodedJql = encodeURIComponent(jql);
    String ncodedJql = filter.jql;

    String path = URL_JQL + '?maxResults=' + MAX_RESULTS.toString() + "&fields=" + FIELDS_TO_GET + '&jql=' + ncodedJql;

    var _validateResult = (JiraSearch res) {
      if (res.total > MAX_RESULTS || res.total > res.maxResults) {
        throw new Exception(AjaxError.LIMIT_REACHED + MAX_RESULTS.toString());
      } else if (res.total == 0) {
        throw new Exception(AjaxError.EMPTY_JQL_RESULT);
      }
    };

    var _validateResponse = (Response resp) {
      if (resp.statusCode >= 400) {
        var msg = (resp.body != null && resp.body.length > 0)
            ? JiraErrorMsg.fromJson(json.decode(resp.body)).errorMessages.reduce((v, e) => v + ';  ' + e)
            : '(No '
            'error response)';
        throw new Exception('Reason: ' + resp.reasonPhrase + '\n' + msg ?? ' - ');
      }
    };

    return _jiraGet(path).then((Response resp) {
      _validateResponse(resp);

      Map jqlMap = json.decode(resp.body);

      var res = JiraSearch.fromJson(jqlMap);

      print('Jql processed: ' + filter.jql);

      _validateResult(res);

      return res;
    });
//        .catchError((err) => print('*** ERROR: ' + err.toString()));
  }
}

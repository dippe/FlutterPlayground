import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:todo_flutter_app/jira/domain/error.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/util/auth.dart';

const URL_ISSUE = "/rest/api/2/issue/";
const URL_JQL = "/rest/api/2/search";

// fixme: this should be configurable on the Config page!
const MAX_RESULTS = 100;
const FIELDS_TO_GET = "*all";
// fixme: re-enable this for performance improvement with finalized fields
//const FIELDS_TO_GET = "status,summary,components,fixVersions,project,issuelinks,issuetype,priority";

class JiraRestClient {
  static Future<Response> _jiraGet(String path) {
    // fixme: rethink this direct store access hack
    final user = store.state.config.user;
    final password = store.state.config.password;
    final baseUrl = store.state.config.baseUrl;
    final fullUrl = baseUrl + path;

    print('*** JIRA get request: ' + fullUrl);
    return BasicAuthClient(user, password).get(fullUrl);
  }

  static Future<JiraIssue> fetchIssue(String key) {
    return _jiraGet(URL_ISSUE + key).then((Response val) {
      print(val.body);

      Map issueMap = json.decode(val.body);

      var issue = JiraIssue.fromJson(issueMap);

      print('Issue processed: ' + issue.key);
      return issue;
    });
//        .catchError((err) => print('*** ERROR: ' + err.toString()));
  }

  static Future<JiraSearch> fetchIssuesByJql(JiraFilter filter) {
    // fixme: re-enable encoding
    //  String ncodedJql = encodeURIComponent(jql);
    String ncodedJql = filter.jql;

    String path = URL_JQL + '?maxResults=' + MAX_RESULTS.toString() + "&fields=" + FIELDS_TO_GET + '&jql=' + ncodedJql;

    return _jiraGet(path)
        .then(_validateResponse)
        .then((resp) => json.decode(resp.body))
        .then((res) => JiraSearch.fromJson(res))
        .catchError((err) => _handleErrors(err));
  }

  static Future<JiraFavouriteFilters> fetchFavouriteFilters() {
    return _jiraGet('/rest/api/2/filter/favourite')
        .then(_validateResponse)
        .then((resp) => json.decode(resp.body) ?? [])
        .then((res) => JiraFavouriteFilters.fromJson(res));
//        .then(_validateJiraVersionsResponse);
  }

  static Future<JiraVersions> fetchVersions(String projectIdOrKey) {
    return _jiraGet('project/' + projectIdOrKey + '/versions')
        .then(_validateResponse)
        .then((resp) => json.decode(resp.body))
        .then((res) => JiraVersions.fromJson(res));
//        .then(_validateJiraVersionsResponse);
  }

  static Future<JiraComponents> fetchComponents(String projectIdOrKey) {
    return _jiraGet('project/' + projectIdOrKey + '/components')
        .then(_validateResponse)
        .then((resp) => json.decode(resp.body))
        .then((res) => JiraComponents.fromJson(res));
//        .then(_validateJiraVersionsResponse);
  }

  static _validateResponse(Response resp) {
    if (resp.statusCode >= 400) {
      try {
        var msg = (resp.body != null && resp.body.length > 0)
            ? JiraErrorMsg.fromJson(json.decode(resp.body)).errorMessages.reduce((v, e) => v + ';  ' + e)
            : '(No error response)';
        throw new HttpException(msg);
      } catch (e) {
        throw new HttpException('Error: ' + resp.reasonPhrase);
      }
    } else {
      return resp;
    }
  }

  static _handleErrors(err) {
    if (err is SocketException) {
      print('Communication Error: ' + err.message);
      throw Exception(err.message);
    } else if (err is HttpException) {
      throw Exception(err.message);
    } else {
      throw UnsupportedError('Data Conversion error. ' + err.message);
    }
  }
}

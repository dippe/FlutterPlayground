import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_flutter_app/examples/state/redux/jira/domain.dart';
import 'package:todo_flutter_app/examples/state/redux/jira/rest.dart';
import 'package:todo_flutter_app/util/auth.dart';

const TMP_USER = "dippenexus@gmail.com";
const TMP_PWD = "KGRCC7h58fgfwKO3ZjKN62C9";
const BASE_URL = "https://testdev1.atlassian.net";

const URL_ISSUE = "/rest/api/2/issue/";
const URL_JQL = "/rest/api/2/search";
const MAX_RESULTS = 1000;
const FIELDS_TO_GET = "status,summary,components,fixVersions,project,issuelinks";

class AjaxError {
  static final LIMIT_REACHED = 'Cannot get all of the issues because the MaxResults limit is reached ';
}

typedef void GetIssueCb(JiraIssue issue);
typedef void GetJqlCb(JiraJqlResult res);

var client = BasicAuthClient(TMP_USER, TMP_PWD);

Future<JiraIssue> fetchIssue(String key, GetIssueCb cb) {
  return client.get(BASE_URL + URL_ISSUE + key).then((Response val) {
    print(val.body);

    Map issueMap = json.decode(val.body);

    var issue = JiraIssue.fromJson(issueMap);

    print('Issue processed: ' + issue.key);
    return issue;
  }).catchError((err) => print('*** ERROR: ' + err.toString()));
}

// fixme cb type
Future<JiraJqlResult> fetchIssuesByJql(String jql, GetJqlCb cb) {
  // fixme: re-enable + test
//  String ncodedJql = encodeURIComponent(jql);
  String ncodedJql = jql;
  String url =
      BASE_URL + URL_JQL + '?maxResults=' + MAX_RESULTS.toString() + "&fields=" + FIELDS_TO_GET + '&jql=' + ncodedJql;

  var _validateResult = (dynamic res) {
    if (res.total > MAX_RESULTS || res.total > res.maxResults) {
      var msg = AjaxError.LIMIT_REACHED + MAX_RESULTS.toString();
      print(msg);
      throw new Exception(msg);
    }
    // fixme: test if list is a real issue list
  };

  return client.get(url).then((Response resp) {
    Map jqlMap = json.decode(resp.body);

    var res = JiraJqlResult.fromJson(jqlMap);

    print('Jql processed: ' + jql);

    cb(res);

    return res;
  }).catchError((err) => print('*** ERROR: ' + err.toString()));
}

import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_flutter_app/examples/state/redux/jira/domain.dart';
import 'package:todo_flutter_app/util/auth.dart';

const TMP_USER = "dippenexus@gmail.com";
const TMP_PWD = "KGRCC7h58fgfwKO3ZjKN62C9";
const BASE_URL = "https://testdev1.atlassian.net";

const URL_ISSUE = "/rest/api/2/issue/";

JiraIssue getIssue(String key) {
  var client = BasicAuthClient(TMP_USER, TMP_PWD);
  var response = client.get(BASE_URL + URL_ISSUE + key);
  response.then((Response val) {
    print(val.body);

    Map issueMap = json.decode(val.body);

    var issue = JiraIssue.fromJson(issueMap);

    print('Issue processed: ' + issue.key);
    return issue;
  });
}

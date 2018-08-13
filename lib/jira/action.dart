import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/util/types.dart';

class FetchError implements Action {
  String error;

  FetchError(this.error);

  @override
  String toString() {
    return 'FetchError{error: $error}';
  }
}

class FetchJqlDone implements Action {
  final JiraSearch jiraJqlResult;
  final JiraFilter jiraFilter;

  FetchJqlDone(this.jiraJqlResult, this.jiraFilter);

  @override
  String toString() {
    return 'FetchJqlDone{res: $jiraJqlResult}';
  }
}

class FetchIssueDone implements Action {
  final JiraIssue issue;

  FetchIssueDone(this.issue);

  @override
  String toString() {
    return 'FetchIssueDone{res: $issue}';
  }
}

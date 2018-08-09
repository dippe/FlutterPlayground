import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';

abstract class Action {}

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

  FetchJqlDone(this.jiraJqlResult);

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

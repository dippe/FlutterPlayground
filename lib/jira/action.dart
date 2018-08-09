import 'package:todo_flutter_app/jira/domain.dart';

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
  final JiraJqlResult jiraJqlResult;

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

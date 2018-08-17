import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/util/types.dart';

class FetchJqlError implements Action {
  final String error;
  final JiraFilter jiraFilter;

  FetchJqlError(this.error, this.jiraFilter);

  @override
  String toString() {
    return 'FetchJqlError{error: $error, jql: ${jiraFilter.jql}}';
  }
}

class FetchIssueError implements Action {
  final String error;

  FetchIssueError(this.error);

  @override
  String toString() {
    return 'FetchIssueError{error: $error}';
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

class FetchJqlStart implements Action {
  final JiraFilter jiraFilter;

  FetchJqlStart(this.jiraFilter);

  @override
  String toString() {
    return 'FetchJqlStart{res: $jiraFilter}';
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

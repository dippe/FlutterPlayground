import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:todo_flutter_app/util/types.dart';

class FetchWarning implements Action {
  final String msg;

  FetchWarning(this.msg);

  @override
  String toString() {
    return 'FetchWarning{error: $msg}';
  }
}

class FetchJqlError implements Action {
  final String error;
  final JiraFilter jiraFilter;

  FetchJqlError(this.error, this.jiraFilter);

  @override
  String toString() {
    return 'FetchJqlError{error: $error, jql: ${jiraFilter.jql}}';
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

class FetchIssueStart implements Action {
  FetchIssueStart();

  @override
  String toString() {
    return 'FetchIssueStart{}';
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

class FetchIssueError implements Action {
  final String error;

  FetchIssueError(this.error);

  @override
  String toString() {
    return 'FetchIssueError{error: $error}';
  }
}

class FetchComponentsStart implements Action {
  FetchComponentsStart();

  @override
  String toString() {
    return 'FetchComponentsStart{}';
  }
}

class FetchComponentsDone implements Action {
  final JiraComponents components;

  FetchComponentsDone(this.components);

  @override
  String toString() {
    return 'FetchComponentsDone{res: $components}';
  }
}

class FetchComponentsError implements Action {
  final String error;

  FetchComponentsError(this.error);

  @override
  String toString() {
    return 'FetchComponentsError{error: $error}';
  }
}

class FetchVersionsStart implements Action {
  FetchVersionsStart();

  @override
  String toString() {
    return 'FetchVersionsStart{}';
  }
}

class FetchVersionsDone implements Action {
  final JiraVersions versions;

  FetchVersionsDone(this.versions);

  @override
  String toString() {
    return 'FetchVersionsDone{res: $versions}';
  }
}

class FetchVersionsError implements Action {
  final String error;

  FetchVersionsError(this.error);

  @override
  String toString() {
    return 'FetchVersionsError{error: $error}';
  }
}

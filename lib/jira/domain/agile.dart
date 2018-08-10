import 'package:todo_flutter_app/jira/domain/issue.dart';

class ScrumIssue {
  final bool done;
  final dynamic estimateStatistic;
  final List<int> fixVersions;
  final bool hasCustomUserAvatar;
  final bool hidden;
  final int id;
  final String key;
  final int linkedPagesCount;
  final String priorityName;
  final String priorityUrl;
  final int projectId;
  final IssueStatus status;
  final int statusId;
  final String statusName;
  final String statusUrl;
  final String summary;
  final int typeId;
  final String typeName;
  final String typeUrl;

  ScrumIssue(
      {this.done,
      this.estimateStatistic,
      this.fixVersions,
      this.hasCustomUserAvatar,
      this.hidden,
      this.id,
      this.key,
      this.linkedPagesCount,
      this.priorityName,
      this.priorityUrl,
      this.projectId,
      this.status,
      this.statusId,
      this.statusName,
      this.statusUrl,
      this.summary,
      this.typeId,
      this.typeName,
      this.typeUrl});
}

class ChildIssue {
  final String summary;
  final int id;
  final String key;
  final String typeIconUrl;
  final IssueStatus status;

  ChildIssue({this.summary, this.id, this.key, this.typeIconUrl, this.status});
}

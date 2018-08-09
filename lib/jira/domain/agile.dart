import 'package:todo_flutter_app/jira/domain/issue.dart';

class ScrumIssue {
  bool done;
  dynamic estimateStatistic;
  List<int> fixVersions;
  bool hasCustomUserAvatar;
  bool hidden;
  int id;
  String key;
  int linkedPagesCount;
  String priorityName;
  String priorityUrl;
  int projectId;
  IssueStatus status;
  int statusId;
  String statusName;
  String statusUrl;
  String summary;
  int typeId;
  String typeName;
  String typeUrl;
}

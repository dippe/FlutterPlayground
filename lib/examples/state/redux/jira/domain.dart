class TJiraUser {
  bool active;
  String avatarUrls;
  String displayName;
  String emailAddress;
  String key;
  String name;
  String self;
  String timeZone;
}

class TIssueComponent {
  int id;
  String name;
  String self;
}

class TIssueType {
  String description;
  String iconUrl;
  String id; // int
  String name;
  String self;
  bool subtask;
}

class TIssueStatusCategory {
  String colorName;
  String id; // int
  String key;
}

class TIssueStatus {
  String description;
  String iconUrl;
  String id; // int
  String name;
  TIssueStatusCategory statusCategory;
  String self;
}

class TJiraIssueFields {
  dynamic aggregateprogress;
  dynamic aggregatetimeestimate;
  dynamic aggregatetimeoriginalestimate;
  dynamic aggregatetimespent;
  TJiraUser assignee;
  List<TIssueComponent> components;
  String created; // "2017-03-07T19:03:46.422+0100"
  TJiraUser creator;
  String description;
  dynamic duedate;
  List<dynamic> fixVersions;
  List<dynamic> issuelinks;
  TIssueType issuetype;
  List<dynamic> labels;
  String lastViewed; // "2017-03-07T19:03:46.422+0100"
  dynamic priority;
  dynamic progress;
  dynamic project;
  TJiraUser reporter;
  dynamic resolution;
  String resolutiondate; // "2017-03-07T19:03:46.000+0100"
  TIssueStatus status;
  List<dynamic> subtasks;
  String summary;
  dynamic timeestimate;
  dynamic timeoriginalestimate;
  dynamic timespent;
  String updated; // "2017-03-07T19:03:46.000+0100"
  List<dynamic> versions;
  dynamic votes;
  dynamic watches;
  dynamic workratio;
}

class TJiraIssue {
  String key;
  String typeUrl;
  TJiraIssueFields fields;
}

class TScrumIssue {
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
  TIssueStatus status;
  int statusId;
  String statusName;
  String statusUrl;
  String summary;
  int typeId;
  String typeName;
  String typeUrl;
}

class ChildIssue {
  String summary;
  int id;
  String key;
  String typeIconUrl;
  IssueStatus status;
}

class IssueStatus {
  String id;
  String name;
  String description;
  String iconUrl;
  String colorName;
}

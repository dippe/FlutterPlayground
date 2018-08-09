class StatusName {
  static final CLOSED = 'Closed';
  static final DONE = 'Done';
  static final IN_PROGRESS = 'In Progress';
  static final UNDEFINED = '??';
}

class JiraUser {
  bool active;
  dynamic avatarUrls; // fixme type
  String displayName;
  String emailAddress;
  String key;
  String name;
  String self;
  String timeZone;

  JiraUser.fromJson(Map<String, dynamic> json)
      : active = json['active'],
        avatarUrls = json['avatarUrls'],
        displayName = json['displayName'],
        emailAddress = json['emailAddress'],
        key = json['key'],
        name = json['name'],
        self = json['self'],
        timeZone = json['timeZone'];
}

class IssueComponent {
  int id;
  String name;
  String self;

  IssueComponent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        self = json['self'];
}

class IssueType {
  String description;
  String iconUrl;
  String id; // int
  String name;
  String self;
  bool subtask;

  IssueType.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        iconUrl = json['iconUrl'],
        id = json['id'],
        name = json['name'],
        self = json['self'],
        subtask = json['subtask'];
}

class IssueStatusCategory {
  String colorName;
  int id;
  String key;

  IssueStatusCategory.fromJson(Map<String, dynamic> json)
      : colorName = json['colorName'],
        id = json['id'],
        key = json['key'];
}

class IssueStatus {
  String description;
  String iconUrl;
  String id; // int
  String name;
  IssueStatusCategory statusCategory;
  String self;

  IssueStatus.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        iconUrl = json['iconUrl'],
        id = json['id'],
        name = json['name'],
        statusCategory = IssueStatusCategory.fromJson(json['statusCategory']),
        self = json['self'];
}

class JiraIssueFields {
  dynamic aggregateprogress;
  dynamic aggregatetimeestimate;
  dynamic aggregatetimeoriginalestimate;
  dynamic aggregatetimespent;
  JiraUser assignee;
  List<IssueComponent> components;
  String created; // "2017-03-07T19:03:46.422+0100"
  JiraUser creator;
  String description;
  dynamic duedate;
  List<dynamic> fixVersions;
  List<dynamic> issuelinks;
  IssueType issuetype;
  List<dynamic> labels;
  String lastViewed; // "2017-03-07T19:03:46.422+0100"
  dynamic priority;
  dynamic progress;
  dynamic project;
  JiraUser reporter;
  dynamic resolution;
  String resolutiondate; // "2017-03-07T19:03:46.000+0100"
  IssueStatus status;
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

  JiraIssueFields.unlinked(this.summary);

  JiraIssueFields.fromJson(Map<String, dynamic> json)
      : aggregateprogress = json['aggregateprogress'],
        aggregatetimeestimate = json['aggregatetimeestimate'],
        aggregatetimeoriginalestimate = json['aggregatetimeoriginalestimate'],
        aggregatetimespent = json['aggregatetimespent'],
        assignee = json['assignee'] != null ? JiraUser.fromJson(json['assignee']) : null,
        components = (json['components'] as List<dynamic>).map((item) => IssueComponent.fromJson(item)).toList()
            as List<IssueComponent>, //
        created = json['created'], // "2017-03-07T19:03:46.422+0100"
        creator = json['creator'] != null ? JiraUser.fromJson(json['creator']) : null,
        description = json['description'],
        duedate = json['duedate'],
        fixVersions = json['fixVersions'],
        issuelinks = json['issuelinks'],
        issuetype = json['issuetype'] != null ? IssueType.fromJson(json['issuetype']) : null,
        labels = json['labels'],
        lastViewed = json['lastViewed'], // "2017-03-07T19:03:46.422+0100"
        priority = json['priority'],
        progress = json['progress'],
        project = json['project'],
        reporter = json['reporter'] != null ? JiraUser.fromJson(json['reporter']) : null,
        resolution = json['resolution'],
        resolutiondate = json['resolutiondate'], // "2017-03-07T19:03:46.000+0100"
        status = json['status'] != null ? IssueStatus.fromJson(json['status']) : null,
        subtasks = json['subtasks'],
        summary = json['summary'],
        timeestimate = json['timeestimate'],
        timeoriginalestimate = json['timeoriginalestimate'],
        timespent = json['timespent'],
        updated = json['updated'], // "2017-03-07T19:03:46.000+0100"
        versions = json['versions'],
        votes = json['votes'],
        watches = json['watches'],
        workratio = json['workratio'];
}

class JiraIssue {
  final String id;
  final String key;
  final String typeUrl;
  final JiraIssueFields fields;

  JiraIssue.unlinked(key, summary)
      : key = key,
        fields = JiraIssueFields.unlinked(summary),
        id = null,
        typeUrl = null;

  JiraIssue.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        typeUrl = json['typeUrl'],
        fields = JiraIssueFields.fromJson(json['fields']);
}

class ChildIssue {
  String summary;
  int id;
  String key;
  String typeIconUrl;
  IssueStatus status;
}

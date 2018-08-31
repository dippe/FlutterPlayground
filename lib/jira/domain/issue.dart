import 'package:json_annotation/json_annotation.dart';
part 'issue.g.dart';

class StatusName {
  static const CLOSED = 'Closed';
  static const DONE = 'Done';
  static const IN_PROGRESS = 'In Progress';
  static const UNDEFINED = '??';
}

@JsonSerializable()
class JiraUser {
  final bool active;
  final dynamic avatarUrls;
  final String displayName;
  final String emailAddress;
  final String key;
  final String name;
  final String self;
  final String timeZone;

  JiraUser({
    this.active,
    this.avatarUrls,
    this.displayName,
    this.emailAddress,
    this.key,
    this.name,
    this.self,
    this.timeZone,
  });

  /*
  JiraUser.fromJson(Map<String, dynamic> json)
      : active = json['active'],
        avatarUrls = json['avatarUrls'],
        displayName = json['displayName'],
        emailAddress = json['emailAddress'],
        key = json['key'],
        name = json['name'],
        self = json['self'],
        timeZone = json['timeZone'];
*/

  factory JiraUser.fromJson(Map<String, dynamic> json) => _$JiraUserFromJson(json);

  Map<String, dynamic> toJson() => _$JiraUserToJson(this);
}

class IssueComponent {
  final int id;
  final String name;
  final String self;

  IssueComponent.fromJson(Map<String, dynamic> json)
      : id = json['id'].runtimeType == String ? int.parse(json['id']) : json['id'],
        name = json['name'],
        self = json['self'];
}

class IssueType {
  final String description;
  final String iconUrl;
  final String id;
  final String name;
  final String self;
  final bool subtask;

  IssueType.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        iconUrl = json['iconUrl'],
        id = json['id'],
        name = json['name'],
        self = json['self'],
        subtask = json['subtask'];
}

class IssueStatusCategory {
  final String colorName;
  final int id;
  final String key;

  IssueStatusCategory.fromJson(Map<String, dynamic> json)
      : colorName = json['colorName'],
        id = json['id'].runtimeType == String ? int.parse(json['id']) : json['id'],
        key = json['key'];
}

class IssueStatus {
  final String description;
  final String iconUrl;
  final String id; // int
  final String name;
  final IssueStatusCategory statusCategory;
  final String self;

  IssueStatus.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        iconUrl = json['iconUrl'],
        id = json['id'],
        name = json['name'],
        statusCategory = IssueStatusCategory.fromJson(json['statusCategory']),
        self = json['self'];
}

class JiraIssueFields {
  final dynamic aggregateprogress;
  final dynamic aggregatetimeestimate;
  final dynamic aggregatetimeoriginalestimate;
  final dynamic aggregatetimespent;
  final JiraUser assignee;
  final List<IssueComponent> components;
  final String created; // "2017-03-07T19:03:46.422+0100"
  final JiraUser creator;
  final String description;
  final dynamic duedate;
  final List<JiraVersion> fixVersions;
  final List<dynamic> issuelinks;
  final IssueType issuetype;
  final List<dynamic> labels;
  final String lastViewed; // "2017-03-07T19:03:46.422+0100"
  final dynamic priority;
  final dynamic progress;
  final JiraProject project;
  final JiraUser reporter;
  final dynamic resolution;
  final String resolutiondate; // "2017-03-07T19:03:46.000+0100"
  final IssueStatus status;
  final List<dynamic> subtasks;
  final String summary;
  final dynamic timeestimate;
  final dynamic timeoriginalestimate;
  final dynamic timespent;
  final String updated; // "2017-03-07T19:03:46.000+0100"
  final List<JiraVersion> versions;
  final dynamic votes;
  final dynamic watches;
  final dynamic workratio;
  final IssueComments comment;

  JiraIssueFields.unlinked(
      {this.aggregateprogress,
      this.aggregatetimeestimate,
      this.aggregatetimeoriginalestimate,
      this.aggregatetimespent,
      this.assignee,
      this.components,
      this.created,
      this.creator,
      this.description,
      this.duedate,
      this.fixVersions,
      this.issuelinks,
      this.issuetype,
      this.labels,
      this.lastViewed,
      this.priority,
      this.progress,
      this.project,
      this.reporter,
      this.resolution,
      this.resolutiondate,
      this.status,
      this.subtasks,
      this.summary,
      this.timeestimate,
      this.timeoriginalestimate,
      this.timespent,
      this.updated,
      this.versions,
      this.votes,
      this.watches,
      this.workratio,
      this.comment});

  JiraIssueFields.fromJson(Map<String, dynamic> json)
      : aggregateprogress = json['aggregateprogress'],
        aggregatetimeestimate = json['aggregatetimeestimate'],
        aggregatetimeoriginalestimate = json['aggregatetimeoriginalestimate'],
        aggregatetimespent = json['aggregatetimespent'],
        assignee = json['assignee'] != null ? JiraUser.fromJson(json['assignee']) : null,
        //ignore: unnecessary_cast
        components = (json['components'] as List<dynamic>).map((item) => IssueComponent.fromJson(item)).toList()
            as List<IssueComponent>, //
        created = json['created'], // "2017-03-07T19:03:46.422+0100"
        creator = json['creator'] != null ? JiraUser.fromJson(json['creator']) : null,
        description = json['description'],
        duedate = json['duedate'],
        //ignore: unnecessary_cast
        fixVersions = (json['fixVersions'] as List<dynamic>).map((item) => JiraVersion.fromJson(item)).toList()
            as List<JiraVersion>,
        issuelinks = json['issuelinks'],
        issuetype = json['issuetype'] != null ? IssueType.fromJson(json['issuetype']) : null,
        labels = json['labels'],
        lastViewed = json['lastViewed'], // "2017-03-07T19:03:46.422+0100"
        priority = json['priority'],
        progress = json['progress'],
        project = json['project'] != null ? JiraProject.fromJson(json['project']) : null,
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
        versions =
            //ignore: unnecessary_cast
            (json['versions'] as List<dynamic>).map((item) => JiraVersion.fromJson(item)).toList() as List<JiraVersion>,
        votes = json['votes'],
        watches = json['watches'],
        workratio = json['workratio'],
        comment = json['comment'] != null ? IssueComments.fromJson(json['comment']) : null;
}

class JiraIssue {
  final String id;
  final String key;
  final String typeUrl;
  final JiraIssueFields fields;
  final Map<String, dynamic> allFields;

  JiraIssue.unlinked(key, summary)
      : key = key,
        fields = JiraIssueFields.unlinked(summary: summary),
        id = null,
        typeUrl = null,
        allFields = {};

  JiraIssue.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        key = json['key'],
        typeUrl = json['typeUrl'],
        fields = JiraIssueFields.fromJson(json['fields']),
        allFields = json['fields'];
}

class JiraVersion {
  final String id;
  final String name;
  final String self;
  final bool archived;
  final bool released;
  final String releaseDate;

  JiraVersion.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        self = json['self'],
        archived = json['archived'],
        released = json['released'],
        releaseDate = json['releaseDate'];
}

class JiraComponent {
  // fixme: unimplemented

  JiraComponent.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Unimplemented JiraComponent converter!');
  }
}

class JiraProject {
  final String key;
  final String name;
  final String id;
  final String self;

  JiraProject({this.key, this.name, this.id, this.self});

  JiraProject.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        name = json['name'],
        id = json['id'].toString(),
        self = json['self'];
}

class IssueComment {
  final String self;
  final String id;
  final JiraUser author;
  final String body;
  final String created;
  final String updated;
  final JiraUser updateAuthor;

  IssueComment({this.self, this.id, this.author, this.body, this.created, this.updated, this.updateAuthor});

  IssueComment.fromJson(Map<String, dynamic> json)
      : self = json['self'],
        id = json['id'],
        author = json['author'] != null ? JiraUser.fromJson(json['author']) : null,
        body = json['body'],
        created = json['created'],
        updated = json['updated'],
        updateAuthor = json['author'] != null ? JiraUser.fromJson(json['updateAuthor']) : null;
}

class IssueComments {
  final List<IssueComment> comments;
  final int maxResults;
  final int total;
  final int startAt;

  IssueComments({this.comments, this.maxResults, this.total, this.startAt});

  IssueComments.fromJson(Map<String, dynamic> json)
      //ignore: unnecessary_cast
      : comments = (json['comments'] as List<dynamic>).map((item) => IssueComment.fromJson(item)).toList()
            as List<IssueComment>, //
        maxResults = json['maxResults'],
        total = json['total'],
        startAt = json['startAt'];
}

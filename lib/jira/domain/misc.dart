import 'package:json_annotation/json_annotation.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
part 'misc.g.dart';

@JsonSerializable()
class JiraFilter {
  final String self; // "htt; ////www.example.com/jira/rest/api/2/filter/10000",
  final String id; // "10000",
  final String name; // "All Open Bugs",
  final String description; // "Lists all open bugs",
  final JiraUser owner; // {
  final String jql; // "type = Bug and resolution is empty",
  final String viewUrl; // "htt; ////www.example.com/jira/issues/?filter=10000",
  final String searchUrl; // www.example.com/jira/rest/api/2/search?jql=type%20...
  final bool favourite; // true,
  final dynamic sharePermissions; // [],
  final dynamic subscriptions;

  JiraFilter({
    this.self,
    this.id,
    this.name,
    this.description,
    this.owner,
    this.jql,
    this.viewUrl,
    this.searchUrl,
    this.favourite,
    this.sharePermissions,
    this.subscriptions,
  }); // {

/*
  JiraFilter.fromJson(Map<String, dynamic> json)
      : self = json['self'],
        id = json['id'],
        name = json['name'],
        description = json['description'],
        owner = json['owner'] != null ? JiraUser.fromJson(json['owner']) : null,
        jql = json['jql'],
        viewUrl = json['viewUrl'],
        searchUrl = json['searchUrl'],
        favourite = json['favourite'],
        sharePermissions = json['sharePermissions'],
        subscriptions = json['subscriptions'];

*/
  @override
  String toString() {
    return 'JiraFilter{id: $id, name: $name}';
  }

  factory JiraFilter.fromJson(Map<String, dynamic> json) => _$JiraFilterFromJson(json);

  Map<String, dynamic> toJson() => _$JiraFilterToJson(this);
}

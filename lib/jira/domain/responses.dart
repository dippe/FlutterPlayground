import 'package:todo_flutter_app/jira/domain/issue.dart';

/*
GET /rest/api/2/search

Searches for issues using JQL.

Sorting the jql parameter is a full JQL expression, and includes an ORDER BY clause.

The fields param (which can be specified multiple times) gives a comma-separated list of fields to include in the response. This can be used to retrieve a subset of fields. A particular field can be excluded by prefixing it with a minus.

By default, only navigable (*navigable) fields are returned in this search resource. Note: the default is different in the get-issue resource -- the default there all fields (*all).

    *all - include all fields
    *navigable - include just navigable fields
    summary,comment - include just the summary and comments
    -description - include navigable fields except the description (the default is *navigable for search)
    *all,-comment - include everything except comments

GET vs POST: If the JQL query is too large to be encoded as a query param you should instead POST to this resource.

Expanding Issues in the Search Result: It is possible to expand the issues returned by directly specifying the expansion on the expand parameter passed in to this resources.

For instance, to expand the "changelog" for all the issues on the search result, it is neccesary to specify "changelog" as one of the values to expand.

Request query parameters
- jql	string: a JQL query string
- startAt	int: the index of the first issue to return (0-based)
- maxResults	int: the maximum number of issues to return (defaults to 50). The maximum allowable value is dictated by
the JIRA property 'jira.search.views.default.max'. If you specify a value that is higher than this number, your search results will be truncated.
- validateQuery	boolean Default: true : whether to validate the JQL query
- fields	string: the list of fields to return for each issue. By default, all navigable fields are returned.
- expand	string A comma-separated list of the parameters to expand.
 */
class JiraSearch {
  String expand;
  int startAt;
  int maxResults;
  int total;
  List<JiraIssue> issues;

  JiraSearch.fromJson(Map<String, dynamic> json)
      : expand = json['expand'],
        startAt = json['startAt'],
        maxResults = json['maxResults'],
        total = json['total'],
        issues = (json['issues'] as List<dynamic>)?.map((issueJson) => JiraIssue.fromJson(issueJson)).toList()
            as List<JiraIssue>;

  @override
  String toString() {
    return 'JiraJqlResult{expand: $expand, startAt: $startAt, maxResults: $maxResults, total: $total, issues: $issues}';
  }
}

/*
GET /rest/api/2/filter/favourite

Returns the favourite filters of the logged-in user.
Request query parameters:
 - expand	string:  // the parameters to expand
 - enableSharedUsers	boolean:  // enable calculating shared users collection, default true
 */
class JiraFavouriteFilters {
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
  final dynamic subscriptions; // {

  JiraFavouriteFilters.fromJson(Map<String, dynamic> json)
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
}

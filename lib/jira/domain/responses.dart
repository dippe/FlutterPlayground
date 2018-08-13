import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';

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
  final DateTime fetchTime;
  final String expand;
  final int startAt;
  final int maxResults;
  final int total;
  final List<JiraIssue> issues;

  JiraSearch.fromJson(Map<String, dynamic> json)
      : expand = json['expand'],
        startAt = json['startAt'],
        maxResults = json['maxResults'],
        total = json['total'],
        //ignore: unnecessary_cast
        issues = (json['issues'] as List<dynamic>)?.map((issueJson) => JiraIssue.fromJson(issueJson))?.toList() as List<JiraIssue>,
        fetchTime = DateTime.now();

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
  final List<JiraFilter> filters;

  JiraFavouriteFilters(this.filters);
}

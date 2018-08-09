/* istanbul ignore next */
//import 'dart:async';
//
//import 'package:todo_flutter_app/examples/state/redux/jira/domain.dart';
//import 'package:todo_flutter_app/examples/state/redux/jira/jira.dart';
//import 'package:todo_flutter_app/util/auth.dart';
//
//class AjaxError {
//  static final INVALID_USER_RESPONSE = 'invalid JIRA User data received in the response';
//  static final INVALID_COMPONENTS_RESPONSE = 'invalid JIRA component array in the response';
//  static final INVALID_VERSION_ARR_RESPONSE = 'invalid JIRA version array in the response';
//  static final MISSING_BULK_ISSUES = 'Missing issues';
//  static final LIMIT_REACHED = 'Cannot get all of the issues because the MaxResults limit is reached ';
//  static final INVALID_RESPONSE_ISSUES = 'Invalid JIRA issue list in the response.';
//  static final XHR_NETWORK_ERROR = 'TypeError: Failed to fetch';
//}
//
//String encodeURIComponent(String str) => throw Exception('unimplemented yet');
//String buildRestUrl(String str) => throw Exception('unimplemented yet');

//const MAX_RESULTS = 1000;
//const FIELDS_TO_GET = "status,summary,components,fixVersions,project,issuelinks";

//BasicAuthClient client = BasicAuthClient(TMP_USER, TMP_PWD);

//// fixme cb type
//Future<List<JiraIssue>> fetchIssuesByJql(String jql, Function cb) {
//  String ncodedJql = encodeURIComponent(jql);
//  String url =
//      buildRestUrl('search?maxResults=' + MAX_RESULTS.toString() + "&fields=" + FIELDS_TO_GET + '&jql=' + ncodedJql);
//
//  Function validateResult = (dynamic res) {
//    if (res.total > MAX_RESULTS || res.total > res.maxResults) {
//      var msg = AjaxError.LIMIT_REACHED + MAX_RESULTS.toString();
//      print(msg);
//      throw new Exception(msg);
//    }
////  else if (!isValidJiraIssues(res.issues)) {
////    console.error(AjaxError.INVALID_RESPONSE_ISSUES
////                  )
//    ;
////    throw(AjaxError.INVALID_RESPONSE_ISSUES);
//  };
//
//  return client.get(url).then((Response res) {
//    return null;
//  });
//}

/////* istanbul ignore next */
////function fetchIssueById(id: String): Promise<JiraIssue> {
////var url: string = buildRestUrl('issue/' + id + '?');
////return checkedFetch(url)
////    .then(value => {
////return value.json();
////});
////}
////
/////* istanbul ignore next */
////function createBulkIssues(issues: Array<BulkIssueCreateRequestD>): Promise<BulkIssueCreateResponse> {
////if (issues && _.isArray(issues) && issues.length > 0) {
////
////var url: string = buildRestUrl('issue/bulk');
////return checkedFetch(url, {
////headers: [
////['Accept', 'application/json'],
////['Content-Type', 'application/json']
////],
////method: 'POST',
////body: JSON.stringify({
////issueUpdates: issues
////})
////})
////    .then(value => value.json())
////    .then(BulkIssueCreateUtil.validateResponse);
////} else {
////throw AjaxError.MISSING_BULK_ISSUES;
////}
////}
////
/////* istanbul ignore next */
////function createIssueLink(type: JiraLinkTypeId, inwardIssueKey: string, outwardIssueKey: string): Promise<boolean> {
////var url: string = buildRestUrl('issueLink');
////
////return checkedFetch(url, {
////headers: [
////['Accept', 'application/json'],
////['Content-Type', 'application/json']
////],
////method: 'POST',
////body: JSON.stringify({
////'type': {
////// 'name': typeName
////'id': type.toString()
////},
////'inwardIssue': {
////'key': inwardIssueKey
////},
////'outwardIssue': {
////'key': outwardIssueKey
////}
////})
////})
////    .then(() => true);   // no response body, only status code
////}
////
////// https://docs.atlassian.com/jira/REST/server/#api/2/project-getProjectVersions
/////* istanbul ignore next */
////function fetchUser(userKey: string): Promise<JiraUser> {
////var url: string = buildRestUrl('user?username=' + userKey + '&expand=groups,applicationRoles');
////return checkedFetch(url)
////    .then(value => value.json())
////    .then((res: JiraUser | any) => {
////if (isValidJiraUser(res)) {
////return (res as JiraUser);
////} else {
////console.error(AjaxError.INVALID_USER_RESPONSE, res);
////throw(AjaxError.INVALID_USER_RESPONSE);
////}
////});
////}
////
////// https://docs.atlassian.com/jira/REST/server/#api/2/project-getProjectVersions
/////* istanbul ignore next */
////function fetchReleases(projectIdOrKey: number | string): Promise<JiraVersions> {
////var url: string = buildRestUrl('project/' + projectIdOrKey + '/versions');
////return checkedFetch(url)
////    .then(value => value.json())
////    .then(function validateJiraVersionsResponse(res: any) {
////if (isValidJiraVersions(res)) {
////return (res);
////} else {
////console.error('invalid JIRA version array in the response', res);
////throw(AjaxError.INVALID_VERSION_ARR_RESPONSE);
////}
////});
////}
////
////// https://docs.atlassian.com/jira/REST/server/#api/2/project-getProjectComponents
////// GET /rest/api/2/project/{projectIdOrKey}/components
/////* istanbul ignore next */
////function fetchComponents(projectIdOrKey: number | string): Promise<JiraComponents> {
////var url: string = buildRestUrl('project/' + projectIdOrKey + '/components');
////return checkedFetch(url)
////    .then(value => value.json())
////    .then(function validateJiraComponentsResponse(res: any) {
////if (isValidJiraComponents(res)) {
////return (res);
////} else {
////throw(AjaxError.INVALID_COMPONENTS_RESPONSE);
////}
////});
////}
////
/////* istanbul ignore next */
////function buildRestUrl(queryStr: string) {
////return TkpGlobals.getRestApiUrl() + queryStr + getDebugStr(queryStr);
////}
////
/////* istanbul ignore next */
////function getDebugStr(queryStr: string) {
////return queryStr.includes('?') ? '&' + DEBUG_LOGIN : '?' + DEBUG_LOGIN;
////}
////
////
/////* istanbul ignore next */
////function isResponse(resp: Response | any): resp is Response {
////if (resp && resp.ok && resp.statusText) {
////return true;
////} else {
////return false;
////}
////}
////
/////* istanbul ignore next */
////function isBulkError(errorResp: BulkIssueCreateResponse | any): errorResp is BulkIssueCreateResponse {
////return errorResp !== undefined && errorResp.errors !== undefined && errorResp.errors.length > 0;
////}
////
/////* istanbul ignore next */
////function isResponseError(respError: Response): respError is Response {
////return respError !== undefined && respError.ok !== undefined;
////}

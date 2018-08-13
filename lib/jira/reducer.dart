import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/action.dart' as Actions;
import 'package:todo_flutter_app/state/domain.dart';

Reducer<JiraData> jiraReducer = (JiraData state, dynamic action) {
  if (action is Actions.FetchJqlDone) {
    var items = action.jiraJqlResult.issues.map((issue) => ListItemData(issue, issue.fields.summary, issue.key)).toList();

    return state.copyWith(
      // fixme: remove (deprecated)
//      todos: state.view.issueListViews[0].copyWith(items: items),
      fetchedIssues: action.jiraJqlResult.issues,
    );
  } else if (action is Actions.FetchIssueDone) {
    throw Exception("unimplemented reducer for Actions.FetchIssueDone");
  } else if (action is Actions.FetchError) {
    print('*** ERROR ***: Fetch error ' + action.error);
    throw Exception("unimplemented reducer FetchError : ");
//    return state.copyWith(error: action.error);
  } else {
    print("jiraReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
};

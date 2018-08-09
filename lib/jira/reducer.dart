import 'package:todo_flutter_app/jira/action.dart' as Actions;
import 'package:todo_flutter_app/state/domain.dart';

TodoAppState jiraReducer(TodoAppState state, dynamic action) {
  if (action is Actions.FetchJqlDone) {
    return state.withIssues(action.jiraJqlResult.issues);
  } else if (action is Actions.FetchIssueDone) {
    throw Exception("unimplemented reducer for Actions.FetchIssueDone");
  } else {
    print("jiraReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
}

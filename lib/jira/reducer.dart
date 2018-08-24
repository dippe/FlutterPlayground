import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/action.dart' as Actions;
import 'package:todo_flutter_app/state/domain.dart';

Reducer<JiraData> jiraReducer = (JiraData state, dynamic action) {
  if (action is Actions.FetchJqlDone) {
    return state.copyWith(
      fetchedIssues: action.jiraJqlResult.issues,
    );
  } else if (action is Actions.FetchFiltersDone) {
    return state.copyWith(fetchedFilters: action.filters);
  } else if (action is Actions.FetchIssueDone) {
    throw Exception("unimplemented reducer for Actions.FetchIssueDone");
  } else if (action is Actions.FetchJqlError) {
    print('*** ERROR ***: unimplemented reducer FetchError ' + action.error);
    return state;
  } else {
    return state;
  }
};

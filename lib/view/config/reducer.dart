import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/config/action.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;

Reducer<ConfigState> configReducer = (ConfigState state, dynamic action) {
  if (action is Actions.SetUserName) {
    return state.copyWith(user: action.name);
  } else if (action is ToggleDisplayModeAction) {
    final newMode = state.listViewMode == ListViewMode.COMPACT ? ListViewMode.NORMAL : ListViewMode.COMPACT;
    return state.copyWith(listViewMode: newMode);
  } else if (action is Actions.SetBaseUrl) {
    return state.copyWith(baseUrl: action.url);
  } else if (action is Actions.SetPwd) {
    return state.copyWith(password: action.pwd);
  } else if (action is Actions.SetMaxIssueKeyLength) {
    return state.copyWith(maxIssueKeyLength: int.parse(action.num));
  } else if (action is Actions.SetMaxJqlIssueNum) {
    return state.copyWith(maxJqlIssueNum: int.parse(action.num));
  } else if (action is Actions.SetRecentIssueCommentsNum) {
    return state.copyWith(recentIssueCommentsNum: int.parse(action.num));
  } else {
    print("configReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
};

import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/config/reducer.dart';
import 'package:todo_flutter_app/view/reducer.dart';

Reducer<AppState> appReducer = (AppState state, dynamic action) {
  if (action is PersistLoadedAction<AppState>) {
    // Load to state + initialize not saved parts with defaults
    return action.state.copyWith(
      jira: initJiraData,
      view: action.state.view.copyWith(messages: initAppMessages),
    );
  } else {
    return new AppState(
      view: viewReducer(state.view, action),
      config: configReducer(state.config, action),
      jira: jiraReducer(state.jira, action),
    );
  }
};

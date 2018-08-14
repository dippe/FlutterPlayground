import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/config/reducer.dart';
import 'package:todo_flutter_app/view/issue_list/reducer.dart';
import 'package:todo_flutter_app/view/jql_tabs/reducer.dart';

AppState appReducer(AppState state, dynamic action) => new AppState(
      view: callReducers([jqlTabsReducer, listViewReducer], state.view, action),
      config: configReducer(state.config, action),
      jira: jiraReducer(state.jira, action),
    );

callReducers(List<Reducer<ViewState>> reducers, state, action) => reducers.fold(state, (state, fn) => fn(state, action));

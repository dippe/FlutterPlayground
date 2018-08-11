import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/config/reducer.dart';
import 'package:todo_flutter_app/view/list/reducer.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
      view: listViewReducer(state.view, action),
      config: configReducer(state.config, action),
      jira: jiraReducer(state.jira, action),
    );

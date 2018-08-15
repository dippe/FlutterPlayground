import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/config/reducer.dart';
import 'package:todo_flutter_app/view/reducer.dart';

Reducer<AppState> appReducer = (AppState state, dynamic action) => new AppState(
      view: viewReducer(state.view, action),
      config: configReducer(state.config, action),
      jira: jiraReducer(state.jira, action),
    );

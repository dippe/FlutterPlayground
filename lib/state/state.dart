import 'dart:async';

import 'package:redux/redux.dart';
import 'package:todo_flutter_app/action.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';

final _initState = TodoAppState(
  todos: Todos(
    items: List.unmodifiable([new TodoData(0, 'Hello world :P', false)]),
    idCounter: 1,
  ),
  todoView: TodoView(false),
  // fixme: remove test data
  login: LoginData(TMP_USER, TMP_PWD),
  issues: null,
);

TodoAppState _debugReducer(TodoAppState state, dynamic action) {
  print('Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
  return state;
}

// todo: beautify this oversimplified composing
final _combinedReducers = (state, action) => todoReducer(jiraReducer(_debugReducer(state, action), action), action);

final store = new Store<TodoAppState>(_combinedReducers, initialState: _initState);

final dispatchConverter = (store) => (Action action) => () => store.dispatch(action);

final dispatchAjaxConverter = (store) => (Future ajax, Function actionCreator) {
      ajax.then((res) => store.dispatch(actionCreator(res)));
    };

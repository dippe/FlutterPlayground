import 'package:redux/redux.dart';
import 'package:todo_flutter_app/action.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';

final _initState = TodoAppState(
  todos: Todos(
    items: List.unmodifiable([new ListItemData(null, 'Hello world :P', 'ISSUE-1')]),
    idCounter: 1,
  ),
  todoView: AppView(false),
  // fixme: remove test data
  login: LoginData(TMP_USER, TMP_PWD),
  fetchedIssues: null,
  view: ViewData(
    selectedIssueListView: '1',
    actual: PageType.IssueList,
    issueListViews: {
      '1': IssueListView(id: '1', filter: JiraFilter(id: '1', jql: 'project=test', name: '1FilterName')),
    },
  ),
);

TodoAppState _debugReducer(TodoAppState state, dynamic action) {
  print('Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
  return state;
}

// todo: beautify this oversimplified composing
final _combinedReducers = (state, action) => todoReducer(jiraReducer(_debugReducer(state, action), action), action);

final store = new Store<TodoAppState>(_combinedReducers, initialState: _initState);

final dispatchConverter = (store) => (Action action) => () => store.dispatch(action);

//final dispatchAjaxConverter = (store) => (Future ajax, Function actionCreator) {
//      ajax.then((res) => store.dispatch(actionCreator(res)));
//    };

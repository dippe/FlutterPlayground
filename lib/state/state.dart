import 'package:redux/redux.dart';
import 'package:todo_flutter_app/action.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/jira/reducer.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';

/// global store "singleton"
final store = new Store<TodoAppState>(_combinedReducers, initialState: _initState);

/// dispatch action into the global store
final dispatch = (Action action) => () => store.dispatch(action);

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
    selectedIssueListView: '2',
    actual: PageType.IssueList,
    issueListViews: {
      '1': IssueListView(id: '1', filter: JiraFilter(id: '1', jql: 'project=test', name: '1 Project Test')),
      '2': IssueListView(id: '2', filter: JiraFilter(id: '2', jql: 'status in ("To Do")', name: '2 Status Todo')),
      // Usable predefined filters:
      '3': IssueListView(
        id: '3',
        filter: JiraFilter(id: '3', jql: 'resolutiondate >= -1w order by updated DESC', name: 'Resolved recently'),
      ),
      '4': IssueListView(
        id: '4',
        filter: JiraFilter(id: '4', jql: 'updated >= -1w order by updated DESC', name: 'Updated recently'),
      ),
      '5': IssueListView(
        id: '5',
        filter: JiraFilter(id: '5', jql: 'created >= -1w order by created DESC', name: 'Created recently'),
      ),
      '6': IssueListView(
        id: '6',
        filter: JiraFilter(id: '6', jql: 'reporter = currentUser() order by created DESC', name: 'Reported by me'),
      ),
      '7': IssueListView(
          id: '7',
          filter: JiraFilter(
              id: '7',
              jql: 'assignee = currentUser() AND resolution = Unresolved order by updated '
                  'DESC',
              name: 'My open issues')),
    },
  ),
);

TodoAppState _debugReducer(TodoAppState state, dynamic action) {
  print('Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
  return state;
}

// todo: beautify this oversimplified composing
final _combinedReducers = (state, action) => todoReducer(jiraReducer(_debugReducer(state, action), action), action);

//final dispatchAjaxConverter = (store) => (Future ajax, Function actionCreator) {
//      ajax.then((res) => store.dispatch(actionCreator(res)));
//    };

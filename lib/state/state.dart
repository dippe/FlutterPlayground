import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/util/types.dart';
import 'package:todo_flutter_app/state/domain.dart';

/// global store "singleton"
final store = new Store<AppState>(combineReducers([_debugReducer, appReducer]), initialState: _initState);

/// dispatch action into the global store
//final dispatchFn = (Action action) => () => store.dispatch(action);
final void Function(Action) dispatch = (Action action) => store.dispatch(action);

/// call multiple reducers of the same state
E callReducers<E>(List<Reducer<E>> reducers, E state, Action action) => reducers.fold(state, (E state, fn) => fn(state, action));

Reducer<AppState> _debugReducer = (AppState state, action) {
  print('*** Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
  return state;
};

Reducer<E> debugReducer<E>(name) => (E state, action) {
      print('*** Reducer: $name  >>> get action: ${action.toString()}');
      return state;
    };

final _initState = AppState(
  jira: JiraData(
    error: null,
    fetchedIssues: null,
    fetchedFilters: null,
    predefinedFilters: _predefinedFilters,
  ),
  // fixme: remove test data
  config: ConfigState(user: TMP_USER, password: TMP_PWD),
  view: ViewState(
    actListIdx: 0,
    actPage: PageType.IssueList,
    issueListViews: [
      IssueListView(
        id: '0',
        name: _predefinedFilters[0].name,
        filter: _predefinedFilters[0],
        result: null,
        items: List.from([new ListItemData(null, 'Hello world :P', 'ISSUE-1')]),
      ),
      IssueListView(
        id: '1',
        name: _predefinedFilters[1].name,
        filter: _predefinedFilters[1],
        result: null,
        items: null,
      ),
      // Usable predefined filters:
      IssueListView(
        id: '2',
        name: _predefinedFilters[2].name,
        filter: _predefinedFilters[2],
        result: null,
        items: null,
      ),
    ],
  ),
);

final List<JiraFilter> _predefinedFilters = [
  JiraFilter(
    name: 'My open issues',
    id: 'predef0',
    jql: 'assignee = currentUser() AND resolution = Unresolved order by updated DESC',
  ),
  JiraFilter(
    id: 'predef1',
    jql: 'status in ("To Do")',
    name: 'Status Todo',
  ),
  JiraFilter(
    id: 'predef2',
    jql: 'resolutiondate >= -1w order by updated DESC',
    name: 'Resolved recently',
  ),
  JiraFilter(
    id: 'predef3',
    jql: 'updated >= -1w or created >= -1w order by updated DESC',
    name: 'Updated recently',
  ),
  JiraFilter(
    id: 'predef4',
    jql: 'reporter = currentUser() order by created DESC',
    name: 'Reported by me',
  ),
  JiraFilter(
    id: 'predef5',
    jql: 'created >= -1w order by created DESC',
    name: 'Created recently',
  ),
];

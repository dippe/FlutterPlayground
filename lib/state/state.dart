import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/util/types.dart';
import 'package:todo_flutter_app/state/domain.dart';

/// global store "singleton"
final store = new Store<AppState>(_debugReducer(appReducer), initialState: _initState);

/// dispatch action into the global store
//final dispatchFn = (Action action) => () => store.dispatch(action);
final dispatch = (Action action) => store.dispatch(action);

Reducer<AppState> _debugReducer(r) => (AppState state, dynamic action) {
      print('Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
      return r(state, action);
    };

final _initState = AppState(
  jira: JiraData(
    error: null,
    fetchedIssues: null,
    fetchedFilters: null,
  ),
  // fixme: remove test data
  config: ConfigState(user: TMP_USER, password: TMP_PWD),
  view: ViewState(
    actPage: PageType.IssueList,
    issueListViews: [
      IssueListView(
        id: '1',
        name: '1 Project Test',
        filter: JiraFilter(id: '1', jql: 'project=test'),
        items: List.from([new ListItemData(null, 'Hello world :P', 'ISSUE-1')]),
        result: [],
      ),
      IssueListView(
        id: '2',
        name: '2 Status Todo',
        filter: JiraFilter(id: '2', jql: 'status in ("To Do")'),
        result: [],
        items: [],
      ),
      // Usable predefined filters:
      IssueListView(
        id: '3',
        name: 'Resolved recently',
        filter: JiraFilter(id: '3', jql: 'resolutiondate >= -1w order by updated DESC'),
        result: [],
        items: [],
      ),
      IssueListView(
        id: '4',
        name: 'Updated recently',
        filter: JiraFilter(id: '4', jql: 'updated >= -1w order by updated DESC'),
        result: [],
        items: [],
      ),
      IssueListView(
        id: '5',
        name: 'Created recently',
        filter: JiraFilter(id: '5', jql: 'created >= -1w order by created DESC'),
        result: [],
        items: [],
      ),
      IssueListView(
        id: '6',
        name: 'Reported by me',
        filter: JiraFilter(id: '6', jql: 'reporter = currentUser() order by created DESC'),
        result: [],
        items: [],
      ),
      IssueListView(
        id: '7',
        name: 'My open issues',
        filter: JiraFilter(
            id: '7',
            jql: 'assignee = currentUser() AND resolution = Unresolved order by updated '
                'DESC'),
        result: [],
        items: [],
      ),
    ],
  ),
);

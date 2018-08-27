import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/state/.config.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/util/types.dart';

const DEBUG = false;

/// global store "singleton"
Store<AppState> store;

Future initStore() async {
  try {
// Create Persistor
    final persistor = Persistor<AppState>(
//      storage: FileStorage("state.json"),
      storage: FlutterStorage("my-jira-app"),
      version: 1,
      decoder: AppState.fromJsonDecoder,
      debug: true,
    );

    store = new Store<AppState>(
      combineReducers([_debugReducer, appReducer]),
      initialState: _initState,
      middleware: [persistor.createMiddleware()],
    );

    // Load initial state
    await persistor.load(store);
    _reloadFirstTab();
  } catch (e) {
    print('***** CRITICAL INIT ERROR' + e);
    throw (e);
  }
}

_reloadFirstTab() {
  final idx = store.state.view?.actListIdx;
  final filter = store.state.view.issueListViews[idx].filter;

  if (filter != null) {
    JiraAjax.doFetchJqlAction(filter);
  }

  JiraAjax.doFetchFilters();
}

/// dispatch action into the global store
//final dispatchFn = (Action action) => () => store.dispatch(action);
final void Function(Action) dispatch = (Action action) => store.dispatch(action);

/// call multiple reducers of the same state
E callReducers<E>(List<Reducer<E>> reducers, E state, Action action) =>
    reducers.fold(state, (E state, fn) => fn(state, action));

Reducer<AppState> _debugReducer = (AppState state, action) {
  print('*** Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
  return state;
};

Reducer<E> debugReducer<E>(name) => (E state, action) {
      if (DEBUG) print('*** Reducer: $name  >>> get action: ${action.toString()}');
      return state;
    };

// init state for first usage
final _initState = AppState(
  jira: initJiraData,
  // fixme: remove test data
  config: ConfigState(
    user: TMP_USER,
    password: TMP_PWD,
    baseUrl: TMP_BASE_URL,
    listViewMode: ListViewMode.COMPACT,
  ),
  view: ViewState(
    search: SearchState(text: null, recent: [], resultItems: null),
    messages: initAppMessages,
    actListIdx: 0,
    actPage: PageType.IssueList,
    issueListViews: [
      IssueListView(
        id: '4',
        name: _predefinedFilters[4].name,
        filter: _predefinedFilters[4],
        result: null,
        items: List.from([new ListItemData(null, 'Hello world :P', 'ISSUELONG-11234')]),
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

// re-usable init state for app-restarts
final JiraData initJiraData = JiraData(
  error: null,
  fetchedIssues: null,
  fetchedFilters: null,
  predefinedFilters: _predefinedFilters,
);

final AppMessages initAppMessages = AppMessages(messages: [], visible: false);

final List<JiraFilter> _predefinedFilters = [
  JiraFilter(
    name: 'My open issues *(PreDef)',
    id: 'predef0',
    jql: 'assignee = currentUser() AND resolution = Unresolved order by updated DESC',
  ),
  JiraFilter(
    id: 'predef1',
    jql: 'status in ("To Do")',
    name: 'Status Todo *(PreDef)',
  ),
  JiraFilter(
    id: 'predef2',
    jql: 'resolutiondate >= -1w order by updated DESC',
    name: 'Resolved recently *(PreDef)',
  ),
  JiraFilter(
    id: 'predef3',
    jql: 'updated >= -1w or created >= -1w order by updated DESC',
    name: 'Updated recently *(PreDef)',
  ),
  JiraFilter(
    id: 'predef4',
    jql: 'reporter = currentUser() order by created DESC',
    name: 'Reported by me *(PreDef)',
  ),
  JiraFilter(
    id: 'predef5',
    jql: 'created >= -1w order by created DESC',
    name: 'Created recently *(PreDef)',
  ),
];

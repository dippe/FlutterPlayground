import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/reducer.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/util/types.dart';
import 'package:todo_flutter_app/view/action.dart';
import 'package:todo_flutter_app/view/messages/action.dart';

const DEBUG = false;

// FIXME !!!!!!! - remove / re-think
const TMP_USER = 'TMP_USER';
const TMP_PWD = 'TMP_PWD';
const TMP_BASE_URL = 'TMP_BASE_URL';


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
      middleware: [_createMiddleware(persistor)],
    );

    // Load initial state
    await persistor.load(store);
    _reloadFirstTab();
  } catch (e) {
    print('***** CRITICAL INIT ERROR' + e.toString());
    if (e is SerializationException) {
      store.dispatch(AddErrorMessageAction('DATA LOAD ERROR!!! \n' + (e as dynamic).message));
    }
    throw (e);
  }
}

/// Middleware used for Redux which saves on each action.
_createMiddleware(persistor) => (Store<AppState> store, dynamic action, NextDispatcher next) async {
      next(action);

      if (action is! PersistAction && _isToBeSaved(store.state)) {
        try {
          // Save
          await persistor.save(store);
        } catch (_) {
          print('************* SAVE ERROR ' + _.toString());
          rethrow;
        }
      }
    };

var _lastStateHash = '';

bool _isToBeSaved(AppState state) {
  final filterHashes = state.view.issueListViews.fold('', (acc, i) => acc + i.filter.hashCode.toString());
  final newHash = state.config.hashCode.toString() + state.view.actPage.toString() + filterHashes;
  if (newHash != _lastStateHash) {
    _lastStateHash = newHash;
    return true;
  } else {
    return false;
  }
}

_reloadFirstTab() {
  final filter1 = store.state.view.issueListViews[0].filter;
  final filter2 = store.state.view.issueListViews[1].filter;
  final filter3 = store.state.view.issueListViews[2].filter;

  JiraAjax.doFetchJqlAction(filter1)
      .then((a) => JiraAjax.doFetchJqlAction(filter2))
      .then((a) => JiraAjax.doFetchJqlAction(filter3))
      .then((a) => JiraAjax.doFetchFilters());

  store.dispatch(ShowActualIssueListPage());
}

/// dispatch action into the global store
//final dispatchFn = (Action action) => () => store.dispatch(action);
final void Function(Action) dispatch = (Action action) => store.dispatch(action);

/// call multiple reducers of the same state
E callReducers<E>(List<Reducer<E>> reducers, E state, Action action) =>
    reducers.fold(state, (E state, fn) => fn(state, action));

Reducer<AppState> _debugReducer = DEBUG
    ? (AppState state, action) {
        print('*** Action triggered with type: ' + action.runtimeType.toString() + ' val: ' + action.toString());
        return state;
      }
    : (AppState state, action) => state;

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
    search: SearchState(text: null, recent: [], resultItems: []),
    messages: initAppMessages,
    actListIdx: 0,
    actPage: PageType.AppStart,
    issueListViews: [
      IssueListView(
        id: '4',
        name: _predefinedFilters[4].name,
        filter: _predefinedFilters[4],
        result: null,
//        items: List.from([new ListItemData(null, 'Hello world :P', 'ISSUELONG-11234')]),
        items: null,
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

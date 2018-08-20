import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart';
import 'package:todo_flutter_app/view/issue_list/reducer.dart';
import 'package:todo_flutter_app/view/jql_tab_edit/reducer.dart';
import 'package:todo_flutter_app/view/jql_tabs/reducer.dart';
import 'package:todo_flutter_app/view/messages/reducer.dart';
import 'package:todo_flutter_app/view/search/reducer.dart';

Reducer<ViewState> viewReducer = combineReducers<ViewState>([
  debugReducer<ViewState>('viewReducer'),
  jqlTabsReducer,
  listViewReducer,
  jqlEditReducer,
  messagesReducer,
  searchReducer,
  TypedReducer<ViewState, ShowSearchPage>(_showSearchPage),
  TypedReducer<ViewState, ShowJqlEditPage>(_showJqlEditPage),
  TypedReducer<ViewState, HideJqlEditPage>(_hideJqlEditPage),
  TypedReducer<ViewState, ShowConfigPage>(_showConfigPage),
  TypedReducer<ViewState, HideConfigPage>(_hideConfigPage),
  TypedReducer<ViewState, ShowActualIssueListPage>(_showActualIssueListPage),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _showSearchPage(ViewState state, ShowSearchPage action) {
  return state.copyWith(actPage: PageType.Search);
}

ViewState _showJqlEditPage(ViewState state, ShowJqlEditPage action) {
  return state.copyWith(actPage: PageType.JqlEdit);
}

ViewState _hideJqlEditPage(ViewState state, HideJqlEditPage action) {
  return state.copyWith(actPage: PageType.IssueList);
}

ViewState _showConfigPage(ViewState state, ShowConfigPage action) {
  return state.copyWith(actPage: PageType.Config);
}

ViewState _hideConfigPage(ViewState state, HideConfigPage action) {
  return state.copyWith(actPage: PageType.IssueList);
}

ViewState _showActualIssueListPage(ViewState state, ShowActualIssueListPage action) {
  return state.copyWith(actPage: PageType.IssueList);
}

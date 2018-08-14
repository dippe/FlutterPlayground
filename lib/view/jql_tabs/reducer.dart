import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/jql_tabs/action.dart' as Actions;

/*
 *
 * All of the view reducers are working on the actually selected list view!!
 * So the actual item list is extracted using the current state's actually selected list idx.
 *
 */
typedef ViewState ViewReducer(ViewState, dynamic);
typedef List<ListItemData> ListModifierFn(List<ListItemData> l);

Reducer<ViewState> jqlTabsReducer = combineReducers<ViewState>([
  TypedReducer<ViewState, Actions.ShowJqlEditDialog>(_showJqlEditDialog),
  TypedReducer<ViewState, Actions.HideJqlEditDialog>(_hideJqlEditDialog),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _showJqlEditDialog(ViewState state, Actions.ShowJqlEditDialog action) {
  return state.copyWith(actPage: PageType.JqlEditDialog);
}

ViewState _hideJqlEditDialog(ViewState state, Actions.HideJqlEditDialog action) {
  return state.copyWith(actPage: PageType.JqlEditDialog);
}

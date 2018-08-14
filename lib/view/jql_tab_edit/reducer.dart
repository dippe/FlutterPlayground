import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/jql_tab_edit//action.dart' as Actions;

/*
 *
 * All of the view reducers are working on the actually selected list view!!
 * So the actual item list is extracted using the current state's actually selected list idx.
 *
 */
typedef ViewState ViewReducer(ViewState, dynamic);
typedef IssueListView ItemModifierFn(IssueListView d);

Reducer<ViewState> listViewReducer = combineReducers<ViewState>([
  TypedReducer<ViewState, Actions.SelectFilter>(_selectFilter),
  TypedReducer<ViewState, Actions.SetName>(_setName),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _setName(ViewState state, Actions.SetName action) {
  return _changeActualListView(state, (view) => view.copyWith(name: action.name));
}

ViewState _selectFilter(ViewState state, Actions.SelectFilter action) {
  return _changeActualListView(state, (view) => view.copyWith(filter: action.filter));
}

/// do modification on the inner items via an immutable way
ViewState _changeActualListView(ViewState state, ItemModifierFn fn) {
  final targetIdx = state.actListIdx;

  // leokádia ... tiszta jáva f@s az elb@szott stream api miatt :D

  if (targetIdx == null) throw ArgumentError('invalid targetIdx: ' + targetIdx.toString());

  final List<IssueListView> listViewsCopy = List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;
  final actual = listViewsCopy[targetIdx];

  final modified = fn(actual);

  // check if the state is mutated somehow
  if (actual == modified) {
    throw ArgumentError('The state is mutated/unchanged by the input function!!');
  }

  listViewsCopy[targetIdx] = modified;

  return state.copyWith(issueListViews: listViewsCopy);
}

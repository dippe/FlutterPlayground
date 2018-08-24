import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/action.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart';
import 'package:todo_flutter_app/view/issue_list/reducer.dart';
import 'package:todo_flutter_app/view/search/action.dart';

/*
 *
 * All of the view reducers are working on the actually selected list view!!
 * So the actual item list is extracted using the current state's actually selected list idx.
 *
 */
typedef SearchState ViewReducer(SearchState, dynamic);
typedef IssueListView ItemModifierFn(IssueListView d);

const int MAX_RECENT_SEARCH_NUM = 20;

Reducer<ViewState> searchReducer = combineReducers<ViewState>([
  debugReducer<ViewState>('searchReducer'),
  TypedReducer<ViewState, FetchSearchDone>(_addItemsFromSearchFetch),
  TypedReducer<ViewState, DoSearchAction>(_doSearch),
  TypedReducer<ViewState, Select>(_select),
  TypedReducer<ViewState, UnSelectAll>(_unSelectAll),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _addItemsFromSearchFetch(ViewState state, FetchSearchDone action) {
  final mapToItems = (List<JiraIssue> issues) {
    final List<ListItemData> listItems = issues
        .map((jiraIssue) => ListItemData(
              jiraIssue,
              jiraIssue.fields?.summary,
              jiraIssue.key,
            ))
        .toList() as List<ListItemData>;

    return listItems;
  };

  try {
    final List<ListItemData> resultItems = mapToItems(action.jiraJqlResult.issues);
    final newSrcState = state.search.copyWith(resultItems: mapToItems(action.jiraJqlResult.issues));
    return state.copyWith(search: newSrcState);
  } catch (e) {
    print('******* EXCEPTION: ' + e.toString());
    return state;
  }
}

ViewState _doSearch(ViewState state, DoSearchAction action) {
  try {
    final List<String> l = List.from(state.search.recent)..add(action.text);
    if (l.length > MAX_RECENT_SEARCH_NUM) {
      l.removeAt(0);
    }

    final newSrcState = state.search.copyWith(text: action.text, recent: l, resetResultItems: true);
    return state.copyWith(search: newSrcState);
  } catch (e) {
    print(e.toString());
    return state;
  }
}

ViewState _unSelectAll(ViewState state, UnSelectAll action) {
  // fixme: re-think this hack:
  if (state.actPage != PageType.Search) {
    return state;
  }

  final newRes = state.search.resultItems
      .map((ListItemData value) => value.copyWith(isSelected: false, isEdit: false))
      .toList() as List<ListItemData>;
  final newSrcState = state.search.copyWith(resultItems: newRes);
  return state.copyWith(search: newSrcState);
}

// fixme: change action payload to key instead of item
ViewState _select(ViewState state, Select action) {
  // fixme: re-think this hack:
  if (state.actPage != PageType.Search) {
    return state;
  }

  final items = state.search.resultItems;

  final select = (l) {
    var item = getByKey(l, action.item.key);
    var idx = getIdxByKey(l, action.item.key);
    l[idx] = item.copyWith(isSelected: true);
    return l;
  };

  _unSelectAll(state, UnSelectAll());
  final newSrcState = state.search.copyWith(resultItems: select(items));
  return state.copyWith(search: newSrcState);
}
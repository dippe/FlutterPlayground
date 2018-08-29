import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/jira/action.dart' as JiraActions;

/*
 *
 * All of the view reducers are working on the actually selected list view!!
 * So the actual item list is extracted using the current state's actually selected list idx.
 *
 */
typedef ViewState ViewReducer(ViewState, dynamic);
typedef List<ListItemData> ListModifierFn(List<ListItemData> l);

Reducer<ViewState> listViewReducer = combineReducers<ViewState>([
  // fixme: move _actListIdx to jql_tabs reducer
  TypedReducer<ViewState, Actions.SetActListIdx>(_actListIdx),
  TypedReducer<ViewState, JiraActions.FetchJqlStart>(_fetchJqlStart),
  TypedReducer<ViewState, JiraActions.FetchJqlDone>(_addItemsFromJqlFetch),
  TypedReducer<ViewState, JiraActions.FetchJqlError>(_fetchJqlError),

  TypedReducer<ViewState, Actions.Add>(_add),
  TypedReducer<ViewState, Actions.Edit>(_edit),
  TypedReducer<ViewState, Actions.Drag>(_drag),
  TypedReducer<ViewState, Actions.Drop>(_drop),
  TypedReducer<ViewState, Actions.Delete>(_delete),
  TypedReducer<ViewState, Actions.SetItemTitle>(_setItemTitle),
  TypedReducer<ViewState, Actions.CbToggle>(_toggle),
  TypedReducer<ViewState, Actions.Select>(_select),
  TypedReducer<ViewState, Actions.UnSelectAll>(_unSelectAll),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _actListIdx(ViewState state, Actions.SetActListIdx action) {
  if (state.actListIdx == action.idx) {
    return state;
  } else {
    return state.copyWith(actListIdx: action.idx);
  }
}

ViewState _add(ViewState state, Actions.Add action) {
  final newItem = ListItemData(action.issue, action.issue.fields.summary, action.issue.key);
  ListModifierFn addTolistFn = (l) {
    if (action.issue != null && getByKey(l, action.issue.key) != null) {
      throw ArgumentError('Item already exists with the same key!');
    }
    l.add(newItem);
    return l;
  };

  return _changeActualItemList(state, addTolistFn);
}

ViewState _fetchJqlStart(ViewState state, JiraActions.FetchJqlStart action) {
  // throw exception when when no element has been found
  bool sameFilterId(IssueListView i) => i.filter.id == action.jiraFilter.id;
//  final IssueListView getViewByFilter = state.issueListViews.firstWhere(sameFilterId);

  final List<IssueListView> listViewsCopy =
      //ignore: unnecessary_cast
      List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;

  final idx = state.issueListViews.indexWhere(sameFilterId);

  if (idx < 0) throw Exception('Cannot find Issue Tab !!!!');

  listViewsCopy[idx] = listViewsCopy[idx].copyWith(resetResult: true);

  return state.copyWith(issueListViews: listViewsCopy);
}

ViewState _addItemsFromJqlFetch(ViewState state, JiraActions.FetchJqlDone action) {
  final mapToItems = (List<JiraIssue> issues) {
    final List<ListItemData> listItems = issues
        .map((jiraIssue) => ListItemData(
              jiraIssue,
              jiraIssue.fields?.summary,
              jiraIssue.key,
            ))
        .toList();

    return listItems;
  };

  // throw exception when when no element has been found
  bool sameFilterId(IssueListView i) => i.filter.id == action.jiraFilter.id;
//  final IssueListView getViewByFilter = state.issueListViews.firstWhere(sameFilterId);

  final List<IssueListView> listViewsCopy =
      //ignore: unnecessary_cast
      List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;

  final idx = state.issueListViews.indexWhere(sameFilterId);

  try {
    listViewsCopy[idx] = listViewsCopy[idx].copyWith(
      items: mapToItems(action.jiraJqlResult.issues),
      result: action.jiraJqlResult,
    );
  } catch (e) {
    print(e.toString());
  }

  return state.copyWith(issueListViews: listViewsCopy);
}

ViewState _fetchJqlError(ViewState state, JiraActions.FetchJqlError action) {
  // throw exception when when no element has been found
  bool sameFilterId(IssueListView i) => i.filter.id == action.jiraFilter.id;
//  final IssueListView getViewByFilter = state.issueListViews.firstWhere(sameFilterId);

  final List<IssueListView> listViewsCopy =
      //ignore: unnecessary_cast
      List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;

  final idx = state.issueListViews.indexWhere(sameFilterId);

  try {
    listViewsCopy[idx] = listViewsCopy[idx].copyWith(
      error: action.error,
      items: [],
      resetResult: true,
    );
  } catch (e) {
    print(e.toString());
    rethrow;
  }

  return state.copyWith(issueListViews: listViewsCopy);
}

ViewState _delete(ViewState state, Actions.Delete action) {
  ListModifierFn addTolistFn = (l) => l..remove(action.item);
  return _changeActualItemList(state, addTolistFn);
}

ViewState _drag(ViewState state, Actions.Drag action) {
  throw UnimplementedError('Drag action');
}

ViewState _drop(ViewState state, Actions.Drop action) {
  final ListModifierFn addTolistFn = (l) => _withMoved(l, action.dragged, action.target);
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, addTolistFn);
}

ViewState _edit(ViewState state, Actions.Edit action) {
  final ListModifierFn edit = (l) {
    var idx = l.indexOf(getByKey(l, action.item.key));
    l[idx] = l[idx].copyWith(isEdit: true);
    return l;
  };

  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, edit);
}

ViewState _unSelectAll(ViewState state, Actions.UnSelectAll action) {
  ListModifierFn unSelectAll = (List<ListItemData> l) =>
      //ignore: unnecessary_cast
      l.map((ListItemData value) => value.copyWith(isSelected: false, isEdit: false)).toList() as List<ListItemData>;
  return _changeActualItemList(state, unSelectAll);
}

ViewState _toggle(ViewState state, Actions.CbToggle action) {
  final ListModifierFn set = (l) {
    var idx = l.indexOf(getByKey(l, action.item.key));
    l[idx] = l[idx].copyWith(done: !l[idx].done);
    return l;
  };
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, set);
}

// fixme: change action payload to key instead of item
ViewState _select(ViewState state, Actions.Select action) {
  final ListModifierFn select = (l) {
    var item = getByKey(l, action.item.key);
    var idx = getIdxByKey(l, action.item.key);
    l[idx] = item.copyWith(isSelected: true);
    return l;
  };
  // fixme? optimization of state change somehow?
  //  return state..issueListViews[0].items[0] = state.issueListViews[0].items[0].copyWith(title: '1234');

  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, select);
}

ViewState _setItemTitle(ViewState state, Actions.SetItemTitle action) {
  final ListModifierFn set = (l) {
    var idx = l.indexOf(getByKey(l, action.key));
    l[idx] = l[idx].copyWith(title: action.title);
    return l;
  };
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, set);
}

/* ***********
*
*    Utils
*
* ************/

/// list item util
ListItemData getByKey(List<ListItemData> items, String key) {
  return items.firstWhere((i) => i.key == key, orElse: () => null);
}

/// list item util
int getIdxByKey(items, String key) {
  var item = getByKey(items, key);
  var idx = items.indexOf(item);

  return idx;
}

List<ListItemData> _withMoved(items, ListItemData what, ListItemData target) {
  final List<ListItemData> copy = List.from(items);

  copy.remove(what);
  final newIndex = copy.indexOf(target);
  copy.insert(newIndex, what);

  return copy;
}

/// do modification on the inner items via an immutable way
ViewState _changeActualItemList(ViewState state, ListModifierFn fn) {
  // fixme: re-think this hack:
  if (state.actPage != PageType.IssueList) {
    return state;
  }

  final targetIdx = state.actListIdx;

  // leokádia ... tiszta jáva f@s az elb@szott stream api miatt :D

  if (targetIdx == null) throw ArgumentError('invalid targetIdx: ' + targetIdx.toString());

  final List<IssueListView> listViewsCopy =
      //ignore: unnecessary_cast
      List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;
  final origItems = listViewsCopy[targetIdx].items;
  //ignore: unnecessary_cast
  final itemsCopy = List<ListItemData>.of(origItems).toList() as List<ListItemData>; // rethink if this really needed

  final updatedItems = fn(itemsCopy);

  listViewsCopy[targetIdx] = listViewsCopy[targetIdx].copyWith(items: updatedItems);

  return state.copyWith(issueListViews: listViewsCopy);
}

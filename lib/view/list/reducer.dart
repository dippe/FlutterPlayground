import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/config/action.dart' as Actions;
import 'package:todo_flutter_app/view/list/action.dart' as Actions;

/**
 * All of the view reducers are working on the actually selected list view!!
 *
 */
typedef ViewState ViewReducer(ViewState, dynamic);
typedef List<ListItemData> ListModifierFn(List<ListItemData> l);

Reducer<ViewState> listViewReducer = combineReducers<ViewState>([
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

/// do modification on the inner items via an immutable way
ViewState _changeActualItemList(ViewState state, ListModifierFn fn) {
  // FIXME: add state
  final targetIdx = 0;
  print('MISSING STATE FOR INDEX IN VIEW REDUCER!!!!');

  // leokádia ... tiszta jáva f@s az elb@szott stream api miatt :D

  if (targetIdx == null) throw ArgumentError('invalid targetIdx: ' + targetIdx.toString());

  final List<IssueListView> listViewsCopy =
      List<IssueListView>.from(state.issueListViews).toList() as List<IssueListView>;
  final origItems = listViewsCopy[targetIdx].items;
  final itemsCopy = List<ListItemData>.of(origItems).toList() as List<ListItemData>; // rethink if this really needed

  final updatedItems = fn(itemsCopy);

  listViewsCopy[targetIdx] = listViewsCopy[targetIdx].copyWith(items: updatedItems);

  return state.copyWith(issueListViews: listViewsCopy);
}

ViewState _add(ViewState state, Actions.Add action) {
  final newItem = ListItemData(action.issue, action.issue.fields.summary, action.issue.key);
  ListModifierFn addTolistFn = (l) {
    if (action.issue != null && _getByKey(l, action.issue.key) != null) {
      throw ArgumentError('Item already exists with the same key!');
    }
    l.add(newItem);
    return l;
  };
  return _changeActualItemList(state, addTolistFn);
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
    var idx = l.indexOf(_getByKey(l, action.item.key));
    l[idx] = l[idx].copyWith(isEdit: true);
    return l;
  };

  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, edit);
}

ViewState _unSelectAll(ViewState state, Actions.UnSelectAll action) {
  ListModifierFn unSelectAll = (List<ListItemData> l) =>
      l.map((ListItemData value) => value.copyWith(isSelected: false, isEdit: false)).toList() as List<ListItemData>;
  return _changeActualItemList(state, unSelectAll);
}

ViewState _toggle(ViewState state, Actions.CbToggle action) {
  final ListModifierFn set = (l) {
    var idx = l.indexOf(_getByKey(l, action.item.key));
    l[idx] = l[idx].copyWith(done: !l[idx].done);
    return l;
  };
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, set);
}

// fixme: change action payload to key instead of item
ViewState _select(ViewState state, Actions.Select action) {
  final ListModifierFn select = (l) {
    var item = _getByKey(l, action.item.key);
    var idx = _getIdxByKey(l, action.item.key);
    l[idx] = item.copyWith(isSelected: true);
    return l;
  };
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, select);
}

ViewState _setItemTitle(ViewState state, Actions.SetItemTitle action) {
  final ListModifierFn set = (l) {
    var idx = l.indexOf(_getByKey(l, action.key));
    l[idx] = l[idx].copyWith(title: action.title);
    return l;
  };
  final unselectedState = _unSelectAll(state, Actions.UnSelectAll());
  return _changeActualItemList(unselectedState, set);
}

ListItemData _getByKey(List<ListItemData> items, String key) {
  return items.firstWhere((i) => i.key == key, orElse: () => null);
}

int _getIdxByKey(items, String key) {
  var item = _getByKey(items, key);
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

import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/util/types.dart';
import 'package:todo_flutter_app/view/list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;

/**
 * All of the view reducers are working on the actually selected list view!!
 *
 */
typedef ViewState ViewReducer(ViewState, dynamic);
typedef List ListModifierFn(List l);

Reducer<ViewState> listViewReducer = combineReducers<ViewState>([
  new TypedReducer<ViewState, Actions.Add>(_add),
]);

//IssueListView _getViewState(ViewState state, Action action) => state.issueListViews[action.targetIdx];

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

  listViewsCopy[targetIdx] = listViewsCopy[targetIdx].copyWith(items: itemsCopy);

//  listViewsCopy = updatedItems;
//  listViewsCopy[targetIdx].copyWith(items: updatedItems);

  return state.copyWith(issueListViews: listViewsCopy);
}

ViewState _add(ViewState state, Actions.Add action) {
  final newItem = ListItemData(action.issue, action.issue.fields.summary, action.issue.key);
  ListModifierFn addTolistFn = (List l) => l..add(newItem);
  return _changeActualItemList(state, addTolistFn);
}

//Reducer<ViewState> listViewReducer = (ViewState state, dynamic action) {
//  if (action is Actions.Add) {
//    throw UnimplementedError('Issue add to list reducer');
////    return state.withTodos(state.todos.withNewItem(action.issue));
//  } else if (action is Actions.Delete) {
//    throw UnimplementedError('Issue delete from list reducer');
////    return state.withTodos(state.todos.withDeleted(action.item));
//  } else if (action is Actions.Drag) {
//    throw UnimplementedError('Drag');
//  } else if (action is Actions.Drop) {
//    throw UnimplementedError('Drop');
////    return state.withTodos(state.todos.withAllUnselected().withMoved(action.dragged, action.target));
//  } else if (action is Actions.Edit) {
//    throw UnimplementedError('Edit');
////    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withTitle('').withEdit(true)));
//  } else if (action is Actions.UnSelectAll) {
//    throw UnimplementedError('Unselectall');
////    return state.withTodos(state.todos.withAllUnselected());
//  } else if (action is Actions.CbToggle) {
//    throw UnimplementedError('Toggle');
////    return state.withTodos(state.todos.withUpdated(action.item.withToggled()));
//  } else if (action is Actions.Select) {
//    throw UnimplementedError('Select');
////    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withSelected(true)));
//  } else if (action is Actions.SetItemTitle) {
//    throw UnimplementedError('SetItemTitle');
////    var item = state.todos.items.firstWhere((item) => item.key == action.key);
////    var newTodos = state.todos.withUpdated(item.copyWith(title: action.title));
////    return state.copyWith(todos: newTodos);
//  } else {
//    print("listReducer: unhandled action type: " + action.runtimeType.toString());
//    return state;
//  }
//};

//IssueListView withNewItem(items, JiraIssue issue) {
//  final List<ListItemData> copy = List.from(items);
//  copy.add(ListItemData(issue, issue.fields.summary, issue.key));
//  return items.copyWith(items: copy);
//}

ListItemData _getByKey(items, String key) {
  return items.firstWhere((i) => i.key == key);
}

// fixme: move to reducer
IssueListView withUpdated(items, ListItemData item) {
  final List<ListItemData> copy = List.from(items);
  final index = copy.indexOf(_getByKey(items, item.key));
  copy[index] = item;
  return items.copyWith(items: copy);
}

// fixme: move to reducer
IssueListView withDeleted(items, ListItemData todo) {
  final List<ListItemData> copy = List.from(items);
  copy.remove(_getByKey(items, todo.key));
  return items.copyWith(items: copy);
}

// fixme: move to reducer
IssueListView withAllUnselected(items) {
  List<ListItemData> tmp = items.map((value) => value.withSelected(false).withEdit(false)).toList();
  return items.copyWith(items: tmp);
}

// fixme: move to reducer
IssueListView withMoved(items, ListItemData what, ListItemData target) {
  final List<ListItemData> copy = List.from(items);

  copy.remove(what);
  final newIndex = copy.indexOf(target);
  copy.insert(newIndex, what);

  return items.copyWith(items: copy);
}

import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;

Reducer<ViewState> listViewReducer = (ViewState state, dynamic action) {
  if (action is Actions.Add) {
    throw UnimplementedError('Issue add to list reducer');
//    return state.withTodos(state.todos.withNewItem(action.issue));
  } else if (action is Actions.Delete) {
    throw UnimplementedError('Issue delete from list reducer');
//    return state.withTodos(state.todos.withDeleted(action.item));
  } else if (action is Actions.Drag) {
    throw UnimplementedError('Drag');
  } else if (action is Actions.Drop) {
    throw UnimplementedError('Drop');
//    return state.withTodos(state.todos.withAllUnselected().withMoved(action.dragged, action.target));
  } else if (action is Actions.Edit) {
    throw UnimplementedError('Edit');
//    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withTitle('').withEdit(true)));
  } else if (action is Actions.UnSelectAll) {
    throw UnimplementedError('Unselectall');
//    return state.withTodos(state.todos.withAllUnselected());
  } else if (action is Actions.CbToggle) {
    throw UnimplementedError('Toggle');
//    return state.withTodos(state.todos.withUpdated(action.item.withToggled()));
  } else if (action is Actions.Select) {
    throw UnimplementedError('Select');
//    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withSelected(true)));
  } else if (action is Actions.SetItemTitle) {
    throw UnimplementedError('SetItemTitle');
//    var item = state.todos.items.firstWhere((item) => item.key == action.key);
//    var newTodos = state.todos.withUpdated(item.copyWith(title: action.title));
//    return state.copyWith(todos: newTodos);
  } else {
    print("listReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
};

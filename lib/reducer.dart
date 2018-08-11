import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/action.dart' as Actions;

TodoAppState todoReducer(TodoAppState state, dynamic action) {
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
  } else if (action is Actions.ShowLoginDialog) {
    return state.withTodoView(state.appView.withShowLogin(action.show));
  } else if (action is Actions.Login) {
    return state.withTodoView(state.appView.withShowLogin(false));
  } else if (action is Actions.SetUserName) {
    return state.withLogin(ConfigData(action.name, state.config.password));
  } else if (action is Actions.SetItemTitle) {
    throw UnimplementedError('SetItemTitle');
//    var item = state.todos.items.firstWhere((item) => item.key == action.key);
//    var newTodos = state.todos.withUpdated(item.copyWith(title: action.title));
//    return state.copyWith(todos: newTodos);
  } else if (action is Actions.SetPwd) {
    return state.withLogin(ConfigData(state.config.user, action.pwd));
  } else if (action is Actions.SetPwd) {
    return state.withLogin(ConfigData(state.config.user, action.pwd));
  } else {
    print("todoReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
}

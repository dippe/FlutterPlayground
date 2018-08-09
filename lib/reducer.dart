import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/action.dart' as Actions;

TodoAppState todoReducer(TodoAppState state, dynamic action) {
  if (action is Actions.Add) {
    return state.withTodos(state.todos.withNewItem(action.name));
  } else if (action is Actions.Delete) {
    return state.withTodos(state.todos.withDeleted(action.item));
  } else if (action is Actions.Drag) {
    throw Exception('unimplemented');
  } else if (action is Actions.Drop) {
    return state.withTodos(state.todos.withAllUnselected().withMoved(action.dragged, action.target));
  } else if (action is Actions.Edit) {
    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withTitle('').withEdit(true)));
  } else if (action is Actions.UnSelectAll) {
    return state.withTodos(state.todos.withAllUnselected());
  } else if (action is Actions.CbToggle) {
    return state.withTodos(state.todos.withUpdated(action.item.withToggled()));
  } else if (action is Actions.Select) {
    return state.withTodos(state.todos.withAllUnselected().withUpdated(action.item.withSelected(true)));
  } else if (action is Actions.ShowLoginDialog) {
    return state.withTodoView(state.todoView.withShowLogin(action.show));
  } else if (action is Actions.Login) {
    return state.withTodoView(state.todoView.withShowLogin(false));
  } else if (action is Actions.SetUserName) {
    return state.withLogin(LoginData(action.name, state.login.password));
  } else if (action is Actions.SetPwd) {
    return state.withLogin(LoginData(state.login.user, action.pwd));
  } else {
    print("todoReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
}

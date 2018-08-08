import 'package:meta/meta.dart';
import 'package:todo_flutter_app/examples/state/redux/jira/domain.dart';

enum ConfigMenuItems { About, Config, DisplayFinished, Login }

// fixme: implement hashcodes!!
class TodoData {
  final int id;
  final String title;
  final bool done;
  final bool isEdit;
  final bool isSelected;

  const TodoData(this.id, this.title, this.done, {this.isEdit = false, this.isSelected = false});

  @override
  bool operator ==(other) => other is TodoData && id == (other.id) && title == other.title && done == other.done;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ done.hashCode;

  TodoData withEdit(bool edit) {
    return new TodoData(id, title, done, isEdit: edit, isSelected: edit);
  }

  TodoData withSelected(bool val) {
    return new TodoData(id, title, done, isEdit: isEdit, isSelected: val);
  }

  TodoData withToggled() {
    return TodoData(id, title, !done, isEdit: isEdit, isSelected: isSelected);
  }

  TodoData withTitle(String newTitle) {
    return TodoData(id, newTitle, done, isEdit: false, isSelected: isSelected);
  }
}

class Todos {
  final List<TodoData> items;
  final int idCounter;

  Todos({this.items, this.idCounter = 0});

  Todos withNewItem(String title) {
    final List<TodoData> copy = List.from(items);
    var nextId = idCounter + 1;
    copy.add(TodoData(nextId, title, false));
    return new Todos(items: copy, idCounter: nextId);
  }

  TodoData getById(int id) {
    return items.firstWhere((i) => i.id == id);
  }

  Todos withUpdated(TodoData todo) {
    final List<TodoData> copy = List.from(items);
    final index = copy.indexOf(getById(todo.id));
    copy[index] = todo;
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withDeleted(todo) {
    final List<TodoData> copy = List.from(items);
    copy.remove(getById(todo.id));
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withAllUnselected() {
    List<TodoData> tmp = items.map((value) => value.withSelected(false).withEdit(false)).toList();
    return Todos(
      items: tmp,
      idCounter: idCounter,
    );
  }

  Todos withMoved(TodoData what, TodoData target) {
    final List<TodoData> copy = List.from(items);

    copy.remove(what);
    final newIndex = copy.indexOf(target);
    copy.insert(newIndex, what);

    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  int length() {
    return items.length;
  }

  int lengthDone() {
    return items.where((d) => d.done).length;
  }

  int lengthTodo() {
    return items.where((d) => !d.done).length;
  }

  List<TodoData> list() {
    return items;
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Todos && other.items != null && _itemsEqual(items, other.items) && idCounter == other.idCounter;

  @override
  int get hashCode => items.hashCode ^ idCounter.hashCode;

  bool _itemsEqual(List<TodoData> items, List<TodoData> otherItems) {
    bool isEq = true;
    if (!(otherItems is List<TodoData>)) {
      return false;
    } else {
      return items.every((i) => otherItems.any((o) => o == i));
    }
  }
}

class TodoView {
  final bool showLogin;

  TodoView(this.showLogin);

  TodoView withShowLogin(bool show) {
    return new TodoView(show);
  }

  @override
  String toString() {
    return 'TodoListView{showLogin: $showLogin}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TodoView && runtimeType == other.runtimeType && showLogin == other.showLogin;

  @override
  int get hashCode => showLogin.hashCode;
}

class TodoAppState {
  final List<JiraIssue> issues;
  final Todos todos;
  final TodoView todoView;
  final LoginData login;

  TodoAppState({@required this.issues, @required this.todoView, @required this.todos, @required this.login});

  TodoAppState copyWith({issues, login, todoView, todos}) {
    return TodoAppState(
      issues: issues ?? this.issues,
      login: login ?? this.login,
      todoView: todoView ?? this.todoView,
      todos: todos ?? this.todos,
    );
  }

  // fixme: remove these because unneeded
  TodoAppState withTodos(Todos newElem) => copyWith(todos: newElem);

  TodoAppState withTodoView(TodoView newElem) => copyWith(todoView: newElem);

  TodoAppState withLogin(LoginData newElem) => copyWith(login: newElem);

  TodoAppState withIssues(List<JiraIssue> newElem) => copyWith(issues: newElem);

  @override
  String toString() {
    return 'TodoAppState{todos: $todos, listView: $todoView, login: $login}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAppState &&
          runtimeType == other.runtimeType &&
          todos == other.todos &&
          todoView == other.todoView &&
          login == other.login;

  @override
  int get hashCode => todos.hashCode ^ todoView.hashCode ^ login.hashCode;
}

class LoginData {
  final String user;
  final String password;

  LoginData(this.user, this.password);

  hasLogin() {
    return user != null && password != null;
  }

  @override
  String toString() {
    return 'LoginData{user: $user, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginData && runtimeType == other.runtimeType && user == other.user && password == other.password;

  @override
  int get hashCode => user.hashCode ^ password.hashCode;
}

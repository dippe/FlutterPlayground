import 'package:meta/meta.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';

enum ConfigMenuItems { About, Config, DisplayFinished, Login }

enum PageTypes { Config, IssueList }

class ListItemData {
  final String key;
  final JiraIssue issue;
  final String title;
  final bool done;
  final bool isEdit;
  final bool isSelected;

  const ListItemData(JiraIssue this.issue, String this.title, String this.key,
      {this.isEdit = false, this.isSelected = false, this.done = false});

  @override
  bool operator ==(other) =>
      other is ListItemData && issue == (other.issue) && title == other.title && key == other.key;

  @override
  int get hashCode => issue.hashCode ^ title.hashCode ^ key.hashCode;

  copyWith({String key, issue, title, done, isEdit, isSelected}) => ListItemData(
        issue ?? this.issue,
        title ?? this.title,
        key ?? this.key,
        done: done ?? this.done,
        isEdit: isEdit ?? this.isEdit,
        isSelected: isSelected ?? this.isSelected,
      );

  ListItemData withEdit(bool edit) => copyWith(isEdit: edit);

  ListItemData withSelected(bool val) => copyWith(isSelected: val);

  ListItemData withToggled() => copyWith(done: !this.done);

  ListItemData withTitle(String newTitle) => copyWith(title: newTitle);
}

class Todos {
  final List<ListItemData> items;
  final int idCounter;

  Todos({this.items, this.idCounter = 0});

  copyWith({items, idCounter}) => Todos(items: items ?? this.items, idCounter: idCounter ?? this.idCounter);

  Todos withNewItem(JiraIssue issue) {
    final List<ListItemData> copy = List.from(items);
    var nextId = idCounter + 1;
    copy.add(ListItemData(issue, issue.fields.summary, issue.key));
    return new Todos(items: copy, idCounter: nextId);
  }

  ListItemData getByKey(String key) {
    return items.firstWhere((i) => i.key == key);
  }

  Todos withUpdated(ListItemData item) {
    final List<ListItemData> copy = List.from(items);
    final index = copy.indexOf(getByKey(item.key));
    copy[index] = item;
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withDeleted(todo) {
    final List<ListItemData> copy = List.from(items);
    copy.remove(getByKey(todo.key));
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withAllUnselected() {
    List<ListItemData> tmp = items.map((value) => value.withSelected(false).withEdit(false)).toList();
    return Todos(
      items: tmp,
      idCounter: idCounter,
    );
  }

  Todos withMoved(ListItemData what, ListItemData target) {
    final List<ListItemData> copy = List.from(items);

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

  List<ListItemData> list() {
    return items;
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Todos && other.items != null && _itemsEqual(items, other.items) && idCounter == other.idCounter;

  @override
  int get hashCode => items.hashCode ^ idCounter.hashCode;

  bool _itemsEqual(List<ListItemData> items, List<ListItemData> otherItems) {
    bool isEq = true;
    if (!(otherItems is List<ListItemData>)) {
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
  final String error;

  TodoAppState(
      {@required this.issues, @required this.todoView, @required this.todos, @required this.login, this.error});

  TodoAppState copyWith({error, issues, login, todoView, todos}) {
    return TodoAppState(
      error: error ?? this.error,
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

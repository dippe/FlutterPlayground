import 'package:meta/meta.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';

enum ConfigMenuItems { About, Config, DisplayFinished, Login }

enum PageType { Config, IssueList }

class ListItemData {
  final String key;
  final JiraIssue issue;
  final String title;
  final bool done;
  final bool isEdit;
  final bool isSelected;

  const ListItemData(this.issue, this.title, this.key,
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
    if (!(otherItems is List<ListItemData>)) {
      return false;
    } else {
      return items.every((i) => otherItems.any((o) => o == i));
    }
  }
}

class IssueListView {
  final String id;
  final String name;
  final JiraFilter filter;

  IssueListView({this.id, this.name, this.filter});

  IssueListView copyWith({id, name, filter}) {
    return IssueListView(
      id: id ?? this.id,
      name: name ?? this.name,
      filter: filter ?? this.filter,
    );
  }

  @override
  String toString() {
    return 'IssueListView{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueListView &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          filter == other.filter;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ filter.hashCode;
}

// fixme: remove this view, redundant with ViewData
class AppView {
  final bool showLogin;

  AppView(this.showLogin);

  AppView withShowLogin(bool show) {
    return new AppView(show);
  }

  @override
  String toString() {
    return 'TodoListView{showLogin: $showLogin}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppView && runtimeType == other.runtimeType && showLogin == other.showLogin;

  @override
  int get hashCode => showLogin.hashCode;
}

class ViewData {
  final PageType actual;
  final String selectedIssueListView;
  final Map<String, IssueListView> issueListViews;

  ViewData({this.actual, this.selectedIssueListView, this.issueListViews});

  ViewData copyWith({actual, selectedIssueListView, issueListViews}) {
    return ViewData(
        actual: actual ?? this.actual,
        issueListViews: issueListViews ?? this.issueListViews,
        selectedIssueListView: selectedIssueListView ?? this.selectedIssueListView);
  }
}

class TodoAppState {
  final ViewData view;
  final List<JiraIssue> fetchedIssues;
  final List<JiraFilter> fetchedFilters;
  final Todos todos;
  final AppView todoView;
  final LoginData login;
  final String error;

  TodoAppState({
    @required this.todoView,
    @required this.todos,
    @required this.login,
    @required this.view,
    this.fetchedFilters,
    this.fetchedIssues,
    this.error,
  });

  TodoAppState copyWith({error, fetchedIssues, fetchedFilters, login, appView, todos, view}) {
    return TodoAppState(
      error: error ?? this.error,
      fetchedIssues: fetchedIssues ?? this.fetchedIssues,
      fetchedFilters: fetchedFilters ?? this.fetchedFilters,
      login: login ?? this.login,
      todoView: appView ?? this.todoView,
      todos: todos ?? this.todos,
      view: view ?? this.view,
    );
  }

  // fixme: remove these because unneeded
  TodoAppState withTodos(Todos newElem) => copyWith(todos: newElem);

  TodoAppState withTodoView(AppView newElem) => copyWith(appView: newElem);

  TodoAppState withLogin(LoginData newElem) => copyWith(login: newElem);

  TodoAppState withIssues(List<JiraIssue> newElem) => copyWith(fetchedIssues: newElem);

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

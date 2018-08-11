import 'package:meta/meta.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';

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

class IssueListView {
  final List<ListItemData> items;

  final String id;
  final String name;
  final JiraFilter filter;
  final List<JiraSearch> result; // link to the ajax result
  final int idCounter;

  IssueListView(
      {this.id, @required this.name, @required this.filter, this.result, this.idCounter = 0, @required this.items});

  IssueListView copyWith({id, name, filter, result, items, idCounter}) {
    return IssueListView(
      id: id ?? this.id,
      name: name ?? this.name,
      filter: filter ?? this.filter,
      result: result ?? this.result,
      items: items ?? this.items,
      idCounter: idCounter ?? this.idCounter,
    );
  }

  IssueListView withNewItem(JiraIssue issue) {
    final List<ListItemData> copy = List.from(items);
    var nextId = idCounter + 1;
    copy.add(ListItemData(issue, issue.fields.summary, issue.key));
    return copyWith(items: copy, idCounter: nextId);
  }

  ListItemData getByKey(String key) {
    return items.firstWhere((i) => i.key == key);
  }

  // fixme: move to reducer
  IssueListView withUpdated(ListItemData item) {
    final List<ListItemData> copy = List.from(items);
    final index = copy.indexOf(getByKey(item.key));
    copy[index] = item;
    return copyWith(items: copy);
  }

  // fixme: move to reducer
  IssueListView withDeleted(todo) {
    final List<ListItemData> copy = List.from(items);
    copy.remove(getByKey(todo.key));
    return copyWith(items: copy);
  }

  // fixme: move to reducer
  IssueListView withAllUnselected() {
    List<ListItemData> tmp = items.map((value) => value.withSelected(false).withEdit(false)).toList();
    return copyWith(items: tmp);
  }

  // fixme: move to reducer
  IssueListView withMoved(ListItemData what, ListItemData target) {
    final List<ListItemData> copy = List.from(items);

    copy.remove(what);
    final newIndex = copy.indexOf(target);
    copy.insert(newIndex, what);

    return copyWith(items: copy);
  }

  @deprecated
  int length() {
    return items.length;
  }

  @deprecated
  int lengthDone() {
    return items.where((d) => d.done).length;
  }

  @deprecated
  int lengthTodo() {
    return items.where((d) => !d.done).length;
  }

  // fixme remove later if unneeded
  //  bool _itemsEqual(List<ListItemData> items, List<ListItemData> otherItems) {
  //    if (!(otherItems is List<ListItemData>)) {
  //      return false;
  //    } else {
  //      return items.every((i) => otherItems.any((o) => o == i));
  //    }
  //  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueListView &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          id == other.id &&
          name == other.name &&
          filter == other.filter &&
          result == other.result &&
          idCounter == other.idCounter;

  @override
  int get hashCode =>
      items.hashCode ^ id.hashCode ^ name.hashCode ^ filter.hashCode ^ result.hashCode ^ idCounter.hashCode;
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
  final List<IssueListView> issueListViews;

  ViewData({this.actual, this.issueListViews});

  ViewData copyWith({actual, selectedIssueListView, issueListViews}) {
    return ViewData(
      actual: actual ?? this.actual,
      issueListViews: issueListViews ?? this.issueListViews,
    );
  }
}

class TodoAppState {
  final ViewData view;
  final List<JiraIssue> fetchedIssues;
  final List<JiraFilter> fetchedFilters;
  final AppView appView;
  final ConfigData config;
  final String error;

  TodoAppState({
    @required this.appView,
    @required this.config,
    @required this.view,
    this.fetchedFilters,
    this.fetchedIssues,
    this.error,
  });

  TodoAppState copyWith({error, fetchedIssues, fetchedFilters, config, appView, view}) {
    return TodoAppState(
      error: error ?? this.error,
      fetchedIssues: fetchedIssues ?? this.fetchedIssues,
      fetchedFilters: fetchedFilters ?? this.fetchedFilters,
      config: config ?? this.config,
      appView: appView ?? this.appView,
      view: view ?? this.view,
    );
  }

  TodoAppState withTodoView(AppView newElem) => copyWith(appView: newElem);

  TodoAppState withLogin(ConfigData newElem) => copyWith(config: newElem);

  TodoAppState withIssues(List<JiraIssue> newElem) => copyWith(fetchedIssues: newElem);

  @override
  String toString() {
    return 'TodoAppState{view: $view, fetchedIssues: $fetchedIssues, fetchedFilters: $fetchedFilters, appView: $appView, config: $config, error: $error}';
  }
}

class ConfigData {
  final String user;
  final String password;

  ConfigData(this.user, this.password);

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
      other is ConfigData && runtimeType == other.runtimeType && user == other.user && password == other.password;

  @override
  int get hashCode => user.hashCode ^ password.hashCode;
}

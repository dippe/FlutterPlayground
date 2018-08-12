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

  ListItemData copyWith({String key, issue, title, done, isEdit, isSelected}) => ListItemData(
        issue ?? this.issue,
        title ?? this.title,
        this.key,
        done: done ?? this.done,
        isEdit: isEdit ?? this.isEdit,
        isSelected: isSelected ?? this.isSelected,
      );

//  ListItemData withEdit(bool edit) => copyWith(isEdit: edit);
//
//  ListItemData withSelected(bool val) => copyWith(isSelected: val);
//
//  ListItemData withToggled() => copyWith(done: !this.done);
//
//  ListItemData withTitle(String newTitle) => copyWith(title: newTitle);
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

class ViewState {
  final PageType actPage;
  final List<IssueListView> issueListViews;

  ViewState({@required this.actPage, @required this.issueListViews});

  ViewState copyWith({actual, selectedIssueListView, issueListViews, showLogin}) {
    return ViewState(
      actPage: actual ?? this.actPage,
      issueListViews: issueListViews ?? this.issueListViews,
    );
  }
}

class JiraData {
  final List<JiraIssue> fetchedIssues;
  final List<JiraFilter> fetchedFilters;
  final String error;

  JiraData({this.fetchedIssues, this.fetchedFilters, this.error});

  JiraData copyWith({fetchedIssues, fetchedFilters}) {
    return JiraData(
      fetchedIssues: fetchedIssues ?? this.fetchedIssues,
      fetchedFilters: fetchedFilters ?? this.fetchedFilters,
      error: error ?? this.error,
    );
  }
}

class AppState {
  final JiraData jira;
  final ViewState view;
  final ConfigState config;

  AppState({
    @required this.config,
    @required this.view,
    @required this.jira,
  });

  AppState copyWith({fetchedIssues, fetchedFilters, config, appView, view}) {
    return AppState(
      jira: jira ?? this.jira,
      config: config ?? this.config,
      view: view ?? this.view,
    );
  }

  @deprecated
  AppState withLogin(ConfigState newElem) => copyWith(config: newElem);

  @deprecated
  AppState withIssues(List<JiraIssue> newElem) => copyWith(fetchedIssues: newElem);

  @override
  String toString() {
    return 'AppState{view: $view, jira: $jira, config: $config}';
  }
}

class ConfigState {
  final String user;
  final String password;

  ConfigState({this.user, this.password});

  hasLogin() {
    return user != null && password != null;
  }

  ConfigState copyWith({user, password}) => ConfigState(
        user: user ?? this.user,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return 'LoginData{user: $user, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigState && runtimeType == other.runtimeType && user == other.user && password == other.password;

  @override
  int get hashCode => user.hashCode ^ password.hashCode;
}

import 'package:meta/meta.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';

enum PageType { Config, IssueList, JqlEdit }

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
  final int lastFetched;
  final List<ListItemData> items;

  final String id;
  final String name;
  final JiraFilter filter;
  final JiraSearch result; // link to the ajax result
  final int idCounter;

  IssueListView({
    @required this.id,
    @required this.name,
    @required this.filter,
    @required this.items,
    this.result = null,
    this.idCounter = 0,
    this.lastFetched = null,
  });

  IssueListView copyWith({id, name, filter, result, items, idCounter, bool resetResult = false}) {
    return IssueListView(
      id: id ?? this.id,
      name: name ?? this.name,
      filter: filter ?? this.filter,
      result: resetResult == true ? null : result ?? this.result,
      lastFetched: result != null ? DateTime.now().millisecondsSinceEpoch : this.lastFetched,
      items: items != null ? List<ListItemData>.unmodifiable(items).toList() : this.items,
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
  final AppMessages messages;
  final PageType actPage;
  final List<IssueListView> issueListViews;
  final int actListIdx; // the actual visible list to work on

  ViewState({
    @required this.actPage,
    @required this.issueListViews,
    @required this.actListIdx,
    @required this.messages,
  });

  ViewState copyWith({PageType actPage, int actListIdx, issueListViews, messages}) {
    return ViewState(
      actPage: actPage ?? this.actPage,
      issueListViews:
          issueListViews != null ? List<IssueListView>.unmodifiable(issueListViews).toList() : this.issueListViews,
      actListIdx: actListIdx ?? this.actListIdx,
      messages: messages ?? this.messages,
    );
  }
}

class JiraData {
  final List<JiraIssue> fetchedIssues;
  final List<JiraFilter> fetchedFilters;
  final List<JiraFilter> predefinedFilters;
  final String error;

  JiraData({this.fetchedIssues, this.fetchedFilters, this.error, this.predefinedFilters});

  JiraData copyWith({fetchedIssues, fetchedFilters}) {
    return JiraData(
      fetchedIssues: fetchedIssues != null ? List<JiraIssue>.unmodifiable(fetchedIssues).toList() : this.fetchedIssues,
      fetchedFilters:
          fetchedFilters != null ? List<JiraFilter>.unmodifiable(fetchedFilters).toList() : this.fetchedFilters,
      predefinedFilters: this.predefinedFilters,
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

  AppState copyWith({config, appView, view}) {
    return AppState(
      jira: jira ?? this.jira,
      config: config ?? this.config,
      view: view ?? this.view,
    );
  }

  @override
  String toString() {
    return 'AppState{view: $view, jira: $jira, config: $config}';
  }
}

class ConfigState {
  final String user;
  final String password;
  final String baseUrl;

  ConfigState({@required this.user, @required this.password, @required this.baseUrl});

  hasLogin() {
    return user != null && password != null && baseUrl != null;
  }

  ConfigState copyWith({user, password, baseUrl}) => ConfigState(
        user: user ?? this.user,
        password: password ?? this.password,
        baseUrl: baseUrl ?? this.baseUrl,
      );

  @override
  String toString() {
    return 'ConfigState{server: $baseUrl, user: $user, password: $password}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigState && runtimeType == other.runtimeType && user == other.user && password == other.password;

  @override
  int get hashCode => user.hashCode ^ password.hashCode;
}

enum AppMessageType { ERROR, WARNING, INFO }

class AppMessage {
  final AppMessageType type;
  final String text;

  AppMessage({@required this.type, @required this.text});
}

class AppMessages {
  final List<AppMessage> messages;
  final bool visible;

  AppMessages({@required this.messages, @required this.visible});

  AppMessages copyWith({messages, visible}) => AppMessages(
        visible: visible ?? this.visible,
        messages: messages ?? this.messages,
      );
}

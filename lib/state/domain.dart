import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/domain/responses.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_flutter_app/state/consts.dart';
part 'domain.g.dart';

/**
 * BUILD JSON CONVERTERS: flutter packages pub run build_runner build
 */
enum PageType { Config, IssueList, JqlEdit, Search }

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
}

@JsonSerializable()
class IssueListView {
  @JsonKey(ignore: true, defaultValue: null)
  final int lastFetched;

  // fixme: rethink ignoring (UX?)
  @JsonKey(ignore: true, defaultValue: [], includeIfNull: true)
  final List<ListItemData> items;

  final String id;
  final String name;

  final JiraFilter filter;
  // !!!!!!!!!!!! FIXME: REMOVE THIS LATER
  @JsonKey(ignore: true, defaultValue: null, includeIfNull: true)
  final JiraSearch result; // link to the ajax result
  final int idCounter;

  IssueListView({
    @required this.id,
    @required this.name,
    @required this.filter,
    this.items,
    this.result = null,
    this.idCounter = 0,
    this.lastFetched = null,
  });
//  }) : this.items = items ?? [] as List<ListItemData>;

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

  factory IssueListView.fromJson(Map<String, dynamic> json) => _$IssueListViewFromJson(json);

  Map<String, dynamic> toJson() => _$IssueListViewToJson(this);
}

@JsonSerializable()
class SearchState {
  final List<String> recent;
  final String text;
  @JsonKey(ignore: true, defaultValue: [], includeIfNull: true)
  final List<ListItemData> resultItems;

  SearchState({this.recent, this.text, this.resultItems});

  SearchState copyWith({
    List<String> recent,
    String text,
    List<ListItemData> resultItems,
    bool resetResultItems = false,
  }) {
    return SearchState(
      recent: recent ?? this.recent ?? [],
      text: text ?? this.text ?? '',
      resultItems: resetResultItems ? null : resultItems ?? this.resultItems,
    );
  }

  factory SearchState.fromJson(Map<String, dynamic> json) => _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);
}

@JsonSerializable()
class ViewState {
  @JsonKey(ignore: true, includeIfNull: true, defaultValue: null)
  final AppMessages messages;
  final PageType actPage;
  final List<IssueListView> issueListViews;
  final int actListIdx; // the actual visible list to work on
  final SearchState search;

  ViewState({
    @required this.actPage,
    @required this.issueListViews,
    @required this.actListIdx,
    this.messages,
    @required this.search,
  });

  ViewState copyWith({PageType actPage, int actListIdx, issueListViews, messages, search}) {
    return ViewState(
      actPage: actPage ?? this.actPage,
      issueListViews:
          issueListViews != null ? List<IssueListView>.unmodifiable(issueListViews).toList() : this.issueListViews,
      actListIdx: actListIdx ?? this.actListIdx,
      messages: messages ?? this.messages,
      search: search ?? this.search,
    );
  }

  factory ViewState.fromJson(Map<String, dynamic> json) => _$ViewStateFromJson(json);

  Map<String, dynamic> toJson() => _$ViewStateToJson(this);
}

@JsonSerializable()
class AppState {
  // !!!!!!!!!!!! FIXME: REMOVE THIS LATER
  @JsonKey(ignore: true, defaultValue: null, includeIfNull: true)
  final JiraData jira;
  final ViewState view;
  final ConfigState config;

  AppState({
    @required this.config,
    @required this.view,
    this.jira,
  });

  AppState copyWith({config, jira, view}) {
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

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  static AppState fromJsonDecoder(dynamic json) => AppState.fromJson(json);
}

enum ListViewMode { NORMAL, COMPACT }

@JsonSerializable()
class ConfigState {
  final String user;
  final String password;
  final String baseUrl;
  final ListViewMode listViewMode;
  final int maxJqlIssueNum;
  final int maxIssueKeyLength;
  final int recentIssueCommentsNum;

  ConfigState(
      {@required this.user,
      @required this.password,
      @required this.baseUrl,
      @required this.listViewMode,
      this.maxJqlIssueNum = DEFAULT_MAX_JQL_RESULTS,
      this.maxIssueKeyLength = DEFAULT_MAX_ISSUE_KEY_LENGTH,
      this.recentIssueCommentsNum = DEFAULT_LAST_COMMENT_NUM});

  hasLogin() {
    return user != null && password != null && baseUrl != null;
  }

  ConfigState copyWith(
          {user, password, baseUrl, listViewMode, maxJqlIssueNum, maxIssueKeyLength, recentIssueCommentsNum}) =>
      ConfigState(
        user: user ?? this.user,
        password: password ?? this.password,
        baseUrl: baseUrl ?? this.baseUrl,
        listViewMode: listViewMode ?? this.listViewMode,
        maxJqlIssueNum: maxJqlIssueNum ?? this.maxJqlIssueNum,
        maxIssueKeyLength: maxIssueKeyLength ?? this.maxIssueKeyLength,
        recentIssueCommentsNum: recentIssueCommentsNum ?? this.recentIssueCommentsNum,
      );

  @override
  String toString() {
    return 'ConfigState{server: $baseUrl, user: $user, password: $password}';
  }

  @override
  int get hashCode => user.hashCode ^ password.hashCode;

  factory ConfigState.fromJson(Map<String, dynamic> json) => _$ConfigStateFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigStateToJson(this);
}

/**********************************
 *
 * NOT SERIALIZABLE CLASSES
 *
 */

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

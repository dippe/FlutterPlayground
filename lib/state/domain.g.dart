// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueListView _$IssueListViewFromJson(Map<String, dynamic> json) {
  return IssueListView(
      id: json['id'] as String,
      name: json['name'] as String,
      filter: json['filter'] == null
          ? null
          : JiraFilter.fromJson(json['filter'] as Map<String, dynamic>),
      idCounter: json['idCounter'] as int);
}

Map<String, dynamic> _$IssueListViewToJson(IssueListView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'filter': instance.filter,
      'idCounter': instance.idCounter
    };

SearchState _$SearchStateFromJson(Map<String, dynamic> json) {
  return SearchState(
      recent: (json['recent'] as List)?.map((e) => e as String)?.toList(),
      text: json['text'] as String);
}

Map<String, dynamic> _$SearchStateToJson(SearchState instance) =>
    <String, dynamic>{'recent': instance.recent, 'text': instance.text};

ViewState _$ViewStateFromJson(Map<String, dynamic> json) {
  return ViewState(
      actPage: _$enumDecodeNullable(_$PageTypeEnumMap, json['actPage']),
      issueListViews: (json['issueListViews'] as List)
          ?.map((e) => e == null
              ? null
              : IssueListView.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      actListIdx: json['actListIdx'] as int,
      search: json['search'] == null
          ? null
          : SearchState.fromJson(json['search'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ViewStateToJson(ViewState instance) => <String, dynamic>{
      'actPage': _$PageTypeEnumMap[instance.actPage],
      'issueListViews': instance.issueListViews,
      'actListIdx': instance.actListIdx,
      'search': instance.search
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$PageTypeEnumMap = <PageType, dynamic>{
  PageType.Config: 'Config',
  PageType.IssueList: 'IssueList',
  PageType.JqlEdit: 'JqlEdit',
  PageType.Search: 'Search'
};

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
      config: json['config'] == null
          ? null
          : ConfigState.fromJson(json['config'] as Map<String, dynamic>),
      view: json['view'] == null
          ? null
          : ViewState.fromJson(json['view'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AppStateToJson(AppState instance) =>
    <String, dynamic>{'view': instance.view, 'config': instance.config};

ConfigState _$ConfigStateFromJson(Map<String, dynamic> json) {
  return ConfigState(
      user: json['user'] as String,
      password: json['password'] as String,
      baseUrl: json['baseUrl'] as String,
      listViewMode:
          _$enumDecodeNullable(_$ListViewModeEnumMap, json['listViewMode']),
      maxJqlIssueNum: json['maxJqlIssueNum'] as int,
      maxIssueKeyLength: json['maxIssueKeyLength'] as int,
      recentIssueCommentsNum: json['recentIssueCommentsNum'] as int);
}

Map<String, dynamic> _$ConfigStateToJson(ConfigState instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'baseUrl': instance.baseUrl,
      'listViewMode': _$ListViewModeEnumMap[instance.listViewMode],
      'maxJqlIssueNum': instance.maxJqlIssueNum,
      'maxIssueKeyLength': instance.maxIssueKeyLength,
      'recentIssueCommentsNum': instance.recentIssueCommentsNum
    };

const _$ListViewModeEnumMap = <ListViewMode, dynamic>{
  ListViewMode.NORMAL: 'NORMAL',
  ListViewMode.COMPACT: 'COMPACT'
};

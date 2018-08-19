// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiraFilter _$JiraFilterFromJson(Map<String, dynamic> json) {
  return JiraFilter(
      self: json['self'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      owner: json['owner'] == null
          ? null
          : JiraUser.fromJson(json['owner'] as Map<String, dynamic>),
      jql: json['jql'] as String,
      viewUrl: json['viewUrl'] as String,
      searchUrl: json['searchUrl'] as String,
      favourite: json['favourite'] as bool,
      sharePermissions: json['sharePermissions'],
      subscriptions: json['subscriptions']);
}

Map<String, dynamic> _$JiraFilterToJson(JiraFilter instance) =>
    <String, dynamic>{
      'self': instance.self,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'owner': instance.owner,
      'jql': instance.jql,
      'viewUrl': instance.viewUrl,
      'searchUrl': instance.searchUrl,
      'favourite': instance.favourite,
      'sharePermissions': instance.sharePermissions,
      'subscriptions': instance.subscriptions
    };

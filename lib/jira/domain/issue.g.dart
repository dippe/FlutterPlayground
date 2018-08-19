// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JiraUser _$JiraUserFromJson(Map<String, dynamic> json) {
  return JiraUser(
      active: json['active'] as bool,
      avatarUrls: json['avatarUrls'],
      displayName: json['displayName'] as String,
      emailAddress: json['emailAddress'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      self: json['self'] as String,
      timeZone: json['timeZone'] as String);
}

Map<String, dynamic> _$JiraUserToJson(JiraUser instance) => <String, dynamic>{
      'active': instance.active,
      'avatarUrls': instance.avatarUrls,
      'displayName': instance.displayName,
      'emailAddress': instance.emailAddress,
      'key': instance.key,
      'name': instance.name,
      'self': instance.self,
      'timeZone': instance.timeZone
    };

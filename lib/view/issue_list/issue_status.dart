import 'package:flutter/material.dart';
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/list_item.dart';

const _COLORS = {
  1: Colors.yellow,
  2: Colors.grey,
  3: Colors.green,
  4: Colors.blue,
  5: Colors.red,
};

const _ICONS = {
  1: Icons.device_unknown,
  2: Icons.input,
  3: Icons.arrow_forward,
  4: Icons.done,
};

const URL_STATUS_ICONS = '/images/icons/statuses';
const URL_ISSUETYPE_ICONS = '/images/icons/issuetypes';

const _JIRA_ICON_URLS = {
  'done': URL_STATUS_ICONS + '/resolved.png',
  'indeterminate': URL_STATUS_ICONS + '/inprogress.png',
  'new': URL_STATUS_ICONS + '/open.png',
};

const _COLOR_UNKNOWN = Colors.grey;
const _ICON_UNKNOWN = Icons.table_chart;

Color _getColorByStatusId(int id) => _COLORS[id] ?? _COLOR_UNKNOWN;
// todo: remove later
// ignore: unused_element
Widget _getAvatarByStatusId(int id) => Icon(_ICONS[id] ?? _ICON_UNKNOWN);

ItemWidget wIssueStatusChip = (item) {
  // fixme: remove later this simple hack (direct access to state instead of listening to the state change)
  // fixme: rethink static resources instead of downloading
  final String baseUrl = store.state.config.baseUrl;
  final icon = _JIRA_ICON_URLS[item.issue?.fields?.status?.statusCategory?.key];

  return item.issue?.fields?.status != null
      ? Chip(
          avatar: new Image.network(
            icon != null ? baseUrl + icon : Text('x'),
            color: Colors.white,
//            width: 10.0,
//            height: 10.0,
          ),
          label: Text(
            item.issue.fields.status.name,
            style: TextStyle(),
          ),
          backgroundColor: _getColorByStatusId(item.issue.fields.status.statusCategory.id),
        )
      : Text('-');
};

import 'package:flutter/material.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/view/list/list_item.dart';

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
  return item.issue != null
      ? Chip(
          avatar: new Image.network(
            _JIRA_ICON_URLS[item.issue.fields.status.statusCategory.key],
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

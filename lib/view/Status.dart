import 'package:flutter/material.dart';
import 'package:todo_flutter_app/view/ListItem.dart';

const _COLORS = {
  1: Colors.grey,
  2: Colors.blue,
  3: Colors.yellow,
  4: Colors.green,
  5: Colors.red,
};

const _ICONS = {
  1: Icons.device_unknown,
  2: Icons.input,
  3: Icons.arrow_forward,
  4: Icons.done,
};

const _COLOR_UNKNOWN = Colors.grey;
const _ICON_UNKNOWN = Icons.table_chart;

Color _getColorByStatusId(int id) => _COLORS[id] ?? _COLOR_UNKNOWN;
Widget _getAvatarByStatusId(int id) => Icon(_ICONS[id] ?? _ICON_UNKNOWN);

ItemWidget IssueStatusChip = (item, dispatchFn) {
  return item.issue != null
      ? Chip(
          avatar: new Image.network(item.issue.fields.issuetype.iconUrl),
          label: Text(
            item.issue.fields.status.name,
            style: TextStyle(),
          ),
          backgroundColor: _getColorByStatusId(item.issue.fields.status.statusCategory.id),
        )
      : Text('-');
};

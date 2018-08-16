import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/consts.dart';
import 'package:todo_flutter_app/view/issue_list/list_item.dart';

const _URL_STATUS_ICONS = '/images/icons/statuses';

const _JIRA_ICON_URLS = {
  'done': _URL_STATUS_ICONS + '/resolved.png',
  'indeterminate': _URL_STATUS_ICONS + '/inprogress.png',
  'new': _URL_STATUS_ICONS + '/open.png',
};

Color _getColorByStatusId(int id) => STATUS_COLORS[id] ?? COLOR_UNKNOWN;
// todo: remove later
// ignore: unused_element
Widget _getAvatarByStatusId(int id) => Icon(STATUS_ICONS[id] ?? UNKNOWN_ICON);

ItemWidget wIssueStatusChip = (item) {
  // fixme: remove later this simple hack (direct access to state instead of listening to the state change)
  // fixme: rethink static resources instead of downloading
  final String baseUrl = store.state.config.baseUrl;
  final icon = _JIRA_ICON_URLS[item.issue?.fields?.status?.statusCategory?.key];

  return item.issue?.fields?.status != null
      ? Transform(
          transform: new Matrix4.identity()..scale(0.8),
          child: Chip(
//          shape: Border.all(color: Colors.yellow, width: 1.0),
            avatar: new Image.network(
              icon != null ? baseUrl + icon : Text('x'),
              color: Colors.white,
            ),
            label: Container(
              width: STATUS_CHIP_WIDTH,
              child: Text(
                item.issue.fields.status.name,
                overflow: TextOverflow.fade,
              ),
            ),
            backgroundColor: _getColorByStatusId(item.issue.fields.status.statusCategory.id),
          ),
        )
      : Text('-');
};

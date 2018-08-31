import 'package:flutter/material.dart';
import 'package:todo_flutter_app/view/issue_list/consts.dart';
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';

Color _getColorByStatusId(int id) => STATUS_COLORS[id] ?? COLOR_UNKNOWN;

ItemWidget wIssueStatusChip = (item, bool isCompact) {
  return item.issue?.fields?.status != null
      ? Transform(
          transform: new Matrix4.identity()..scale(0.8),
          child: isCompact
              ? Chip(
                  label: Container(
                    width: STATUS_CHIP_WIDTH * 0.8,
                    child: Text(
                      item.issue.fields.status.name,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  backgroundColor: _getColorByStatusId(item.issue.fields.status.statusCategory.id),
                )
              : Chip(
                  avatar: isCompact ? Text('') : _wStatusIcon(item, isCompact),
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

ItemWidget _wStatusIcon = (item, isCompact) {
  final iconUrl = item.issue?.fields?.status?.iconUrl;
  final statusCtgKey = item.issue?.fields?.status?.statusCategory?.key;
  if (iconUrl != null) {
    final regexp = RegExp(".*\\/(.+.png)");
    final matches = regexp.allMatches(iconUrl);

    try {
      final filename = matches.first.group(1);
      // network solution:
      //      return Image.network(iconUrl);
      // static asset solution:
      return Image.asset('images/statuses/' + filename);
    } catch (e) {
      print('status icon cannot be found');
    }
  }

  if (statusCtgKey != null) {
    return Image.asset(ASSET_STATUS_ICONS[statusCtgKey]);
  } else {
    return Icon(UNKNOWN_ICON);
  }
};

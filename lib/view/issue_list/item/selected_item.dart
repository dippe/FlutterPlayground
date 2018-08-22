import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/consts.dart';
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';

ItemWidget wSelectedItem = (ListItemData item, isCompact) {
  final renderSimpleRow = (children) => Row(
        children: children,
      );
  return renderSimpleRow([
    _wName(item, isCompact),
  ]);
};

Widget _wReadOnlyTitle({
  @required ListItemData item,
  @required Function onTapCb,
  @required Function onDoubleTapCb,
}) {
  // the actual substate is the proper tododata (see the PropertyManager)
  return InkWell(
    onDoubleTap: onDoubleTapCb,
    onTap: onTapCb,
    // todo: kell ez a container?
    child: Container(
      padding: new EdgeInsets.all(10.0),
      // color: new Color(0X9900CCCC),
      child: Text(
        item.title,
        style: TextStyle(decoration: item.done ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    ),
  );
}

ItemWidget _wIssueKey = (item, isCompact) => Chip(
      label: Container(
        width: isCompact ? ISSUEKEY_WIDTH * 0.7 : ISSUEKEY_WIDTH,
        child: Text(
          item.key,
          overflow: TextOverflow.fade,
        ),
      ),
    );

ItemWidget _wPriority = (item, isCompact) {
  if (item?.issue?.fields?.priority != null) {
    final regexp = RegExp(".*\\/(.+).svg");

//    final fileName = regexp.firstMatch(item.issue.fields.priority['iconUrl']);

    final z = regexp.allMatches(item.issue.fields.priority['iconUrl']);

    final filename = z.first.group(1);
    return Image.asset('images/priorities/' + filename + '.png');
  } else {
    return Image.asset('images/issuetypes/blank.png');
  }
};

ItemWidget _wIssuetype = (item, isCompact) {
  if (item.issue != null && item.issue.fields?.issuetype != null) {
    return Image.asset(ASSET_ISSUE_TYPE_ICONS[item.issue.fields.issuetype.name] ?? ASSET_DEFAULT_ISSUE_TYPE_ICON);
  } else {
    return Image.asset(ASSET_DEFAULT_ISSUE_TYPE_ICON);
  }
};

ItemWidget _wName = (item, isCompact) => Expanded(
        child: _wReadOnlyTitle(
      item: item,
      onTapCb: () => dispatch(Actions.Edit(item)),
      onDoubleTapCb: () => dispatch(Actions.Edit(item)),
    ));

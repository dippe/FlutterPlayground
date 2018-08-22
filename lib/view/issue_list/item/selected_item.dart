import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/consts.dart';
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';

ItemWidget wSelectedItem = (ListItemData item, isCompact) {
  return _IssueDetails(item.issue);

  final renderSimpleRow = (children) => Row(
        children: children,
      );
  return renderSimpleRow([
    _wName(item, isCompact),
  ]);
};

Widget _IssueDetails(JiraIssue issue) {
//  issue.key;
  final renderComments = (List<IssueComment> comments) {
    if (comments != null && comments.length > 0) {
      final renderComment = (IssueComment comment) =>
          'Author: ${comment.author} \n' +
          'Created: ${DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(comment.created))} \n' +
          'Comment: ${comment.body}';

      return comments.reversed.take(2).fold('', (val, elem) => '$val${renderComment(elem)} \n\n ');
    } else {
      return ' - ';
    }
  };

  return Container(
    child: Card(
      child: ListView(
        children: <Widget>[
          _IssueField('Key', issue.key),
          _IssueField('Project', issue.fields.project.name),
          _IssueField('Summary', issue.fields.summary),
          _IssueField('Labels',
              issue.fields.labels.length > 0 ? issue.fields.labels.reduce((val, elem) => val + ', ' + elem) : ''),
          _IssueField('Recent Comments', renderComments(issue.fields.comment?.comments)),
          _IssueField('Description', issue.fields.description ?? ''),
        ],
      ),
    ),
    height: 300.0,
  );
}

Widget _IssueField(label, text) => Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(text),
            flex: 3,
          ),
        ],
      ),
    );

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

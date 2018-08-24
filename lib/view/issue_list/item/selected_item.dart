import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';
import 'package:todo_flutter_app/view/issue_list/item/unselected_item.dart';

const _DETAILS_BLOCK_HEIGHT = 400.0;

ItemWidget wSelectedItem = (ListItemData item, isCompact) {
  final onTapCb = (item) => dispatch(Actions.UnSelectAll());
  return Column(
    children: <Widget>[
      ListTile(
        onTap: () => dispatch(Actions.UnSelectAll()),
        title: wItemLineForSelected(item, isCompact, onTapCb, onTapCb),
      ),
      _IssueDetails(item.issue)
    ],
  );

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

      return comments.reversed
          .take(store.state.config.recentIssueCommentsNum)
          .fold('', (val, elem) => '$val${renderComment(elem)} \n\n ');
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
    height: _DETAILS_BLOCK_HEIGHT,
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

ItemWidget _wName = (item, isCompact) => Expanded(
        child: _wReadOnlyTitle(
      item: item,
      onTapCb: () => dispatch(Actions.Edit(item)),
      onDoubleTapCb: () => dispatch(Actions.Edit(item)),
    ));

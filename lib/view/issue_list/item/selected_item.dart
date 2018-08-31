import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter_app/app.dart';
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
      GestureDetector(
        onTap: () => dispatch(Actions.UnSelectAll()),
        child: Container(
          color: Colors.grey.shade800,
          child: wItemLineForSelected(item, isCompact, onTapCb, onTapCb),
        ),
      ),
      _IssueDetails(item.issue),
    ],
  );
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
      child: Column(
        children: <Widget>[
          _IssueField('Prj/Key', issue.fields.project.name + ' [' + issue.key + ']'),
//          _IssueField('Summary', issue.fields.summary),
          // FIXME: remove - ernospec fields
          _IssueField('Cégnév', issue.allFields['customfield_10027'] ?? ''),
          _IssueField('Beosztás', issue.allFields['customfield_10030'] ?? ''),
          _IssueField('Telefon', issue.allFields['customfield_10026'] ?? ''),
          _IssueField('Email', issue.allFields['customfield_10029'] ?? ''),

          // FIXME end
          _IssueField('Labels',
              issue.fields.labels.length > 0 ? issue.fields.labels.reduce((val, elem) => val + ', ' + elem) : ''),
          _IssueField('Recent Comments', renderComments(issue.fields.comment?.comments)),
          _IssueField('Description', issue.fields.description ?? ''),
        ],
      ),
    ),
  );
}

Widget _IssueField(label, String text) => text.trim() == ''
    ? SizedBox(
        height: 0.0,
        width: 0.0,
      )
    : Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: Text(text),
                onLongPress: _copyToClipboardFn(text),
              ),
              flex: 3,
            ),
            // IconButton(icon: Icon(Icons.content_copy), onPressed: _copyToClipboardFn(text)),
          ],
        ),
      );

Widget _wReadOnlyTitle({
  @required ListItemData item,
  @required Function onTapCb,
  @required Function onDoubleTapCb,
}) {
  return InkWell(
    onDoubleTap: onDoubleTapCb,
    onTap: onTapCb,
    child: Container(
      padding: new EdgeInsets.all(10.0),
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

_copyToClipboardFn(text) => () {
      Clipboard.setData(new ClipboardData(text: text));
      (mainGlobalScaffold.currentState as ScaffoldState).showSnackBar(new SnackBar(
        content: new Text("Copied to Clipboard: " + text),
      ));
    };

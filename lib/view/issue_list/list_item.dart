import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/view/issue_list/issue_status.dart';
import 'package:todo_flutter_app/state/domain.dart';

typedef Widget ItemWidget(ListItemData item);

ItemWidget wDraggableListItem = (ListItemData item) {
  return DragTarget<ListItemData>(
    onAccept: (dragged) => (dragged != item) ? dispatch(Actions.Drop(dragged, item)) : null,
    onWillAccept: (dragged) => true,
    builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
      final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
      final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

      return _renderHighlight(wListItem(item));
    },
  );
};

ItemWidget wListItem = (ListItemData item) {
  final renderSimpleRow = (children) => Row(
        children: children,
      );
  final renderUnselectedRow = (children) => _wDraggableItem(
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => dispatch(Actions.CbToggle(item)),
          child: Row(
            children: children,
          ),
        ),
        item,
      );

  if (item.isSelected && item.isEdit) {
    return renderSimpleRow([
      _wName(item),
      _wDeleteBtn(item),
    ]);
  } else if (item.isSelected) {
    return renderSimpleRow([
      _wCheckBox(item),
      _wName(item),
      _wDeleteBtn(item),
    ]);
  } else {
    // fixme: rethink: only JiraIssue or manually created should processed here too?
    return renderUnselectedRow([
      _wIssuetype(item),
      _wPriority(item),
      _wIssueKey(item),
      _wName(item),
      wIssueStatusChip(item),
    ]);
  }
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

ItemWidget _wEditableTitle = (ListItemData item) {
  final d = item;
  final ctrl = new TextEditingController();

  // fixme: remove this later
  ctrl.addListener(() {
    print('ctrl' + ctrl.hashCode.toString() + ' -- ' + d.hashCode.toString());
  });
  ctrl.text = d.title;
  ctrl.value = TextEditingValue(text: d.title);

  return TextField(
    controller: ctrl,
    enabled: true,
    decoration: const InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,
      // icon: const Icon(Icons.short_text),
      hintText: 'What would you like to remember?',
    ),
    keyboardType: TextInputType.text,

    onSubmitted: (String value) {
      dispatch(Actions.SetItemTitle(item.key, value));
    },
    onChanged: (String value) {
//            _debug(context, 'onchanged: ' + value);
      // do not change the state here!!! The auto triggered re-rendering will cause serious perf/rendering issues
    },
    autofocus: true,

    // TextInputFormatters are applied in sequence.
    inputFormatters: [],
  );
};

Widget _wDraggableItem(Widget child, ListItemData item) => LongPressDraggable<ListItemData>(
      child: child,
      feedback: Text(
        'Dragged',
        style: TextStyle(fontSize: 15.0, color: Colors.white, decoration: TextDecoration.none),
      ),
      data: item,
      onDragStarted: () => dispatch(Actions.UnSelectAll()),
      childWhenDragging: Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Divider(height: 2.0, color: Color.fromARGB(255, 255, 0, 0)),
      ),
      onDragCompleted: () => {},
    );

ItemWidget _wDeleteBtn = (item) => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => dispatch(Actions.Delete(item)),
    );

ItemWidget _wCheckBox = (item) => Checkbox(
      value: item.done,
      onChanged: (bool val) => dispatch(Actions.CbToggle(item)),
    );

ItemWidget _wIssueKey = (item) => Text(item.key);

ItemWidget _wPriority = (item) => item?.issue?.fields?.priority != null
    ? Image.network((item.issue.fields.priority['iconUrl'] as String).replaceAll('.svg', '.png'))
    : Text('');

// key: issue type name
const ISSUE_TYPE_ICONS = {
  'Default': URL_ISSUETYPE_ICONS + '/all_unassigned.png',
  'Defect': URL_ISSUETYPE_ICONS + '/defect.png',
  'Story': URL_ISSUETYPE_ICONS + '/story.png',
  'Epic': URL_ISSUETYPE_ICONS + '/epic.png',
  'Task': URL_ISSUETYPE_ICONS + '/task.png',
  'Bug': URL_ISSUETYPE_ICONS + '/bug.png',
  'Sub-task': URL_ISSUETYPE_ICONS + '/subtask.png',
  'Undefined': URL_ISSUETYPE_ICONS + '/undefined.png',

//'' : URL_ISSUETYPE_ICONS + 'documentation.png',
//'' : URL_ISSUETYPE_ICONS + 'feedback.png',
//'' : URL_ISSUETYPE_ICONS + 'improvement.png',
//'' : URL_ISSUETYPE_ICONS + 'request_access.png',
//'' : URL_ISSUETYPE_ICONS + 'task_agile.png',
//'' : URL_ISSUETYPE_ICONS + 'blank.png',
//'' : URL_ISSUETYPE_ICONS + 'delete.png',
//'' : URL_ISSUETYPE_ICONS + 'genericissue.png',
//'' : URL_ISSUETYPE_ICONS + 'newfeature.png',
//'' : URL_ISSUETYPE_ICONS + 'requirement.png',
//'' : URL_ISSUETYPE_ICONS + 'subtask_alternate.png',
//'' : URL_ISSUETYPE_ICONS + 'development_task.png',
//'' : URL_ISSUETYPE_ICONS + 'exclamation.png',
//'' : URL_ISSUETYPE_ICONS + 'health.png',
//'' : URL_ISSUETYPE_ICONS + 'remove_feature.png',
//'' : URL_ISSUETYPE_ICONS + 'sales.png',
};

ItemWidget _wIssuetype = (item) {
  if (item.issue != null && item.issue.fields?.issuetype?.name != null) {
    return Image.network(ISSUE_TYPE_ICONS[item.issue.fields.issuetype.name]);
  } else {
    return Image.network(ISSUE_TYPE_ICONS['Undefined']);
//    return Text('');
  }
};

ItemWidget _wName = (item) => Expanded(
      child: item.isEdit
          ? _wEditableTitle(item)
          : item.isSelected
              ? _wReadOnlyTitle(
                  item: item,
                  onTapCb: () => dispatch(Actions.Edit(item)),
                  onDoubleTapCb: () => dispatch(Actions.Edit(item)),
                )
              : _wReadOnlyTitle(
                  item: item,
                  onTapCb: () => dispatch(Actions.Select(item)),
                  onDoubleTapCb: () => dispatch(Actions.Edit(item)),
                ),
    );

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

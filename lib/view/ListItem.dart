import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/action.dart' as Actions;
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/view/Status.dart';
import 'package:todo_flutter_app/state/domain.dart';

Widget DraggableListItem(ListItemData item, Function dispatchFn) {
  return DragTarget<ListItemData>(
    onAccept: (dragged) => (dragged != item) ? dispatchFn(Actions.Drop(dragged, item))() : null,
    onWillAccept: (dragged) => true,
    builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
      final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
      final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

      return _renderHighlight(ListItem(item, dispatchFn));
    },
  );
}

Widget ListItem(ListItemData item, dispatchFn) {
  final renderSimpleRow = (children) => Row(
        children: children,
      );
  final renderUnselectedRow = (children) => _renderDraggableItem(
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => dispatchFn(Actions.CbToggle(item))(),
          child: Row(
            children: children,
          ),
        ),
        item,
        dispatchFn,
      );

  if (item.isSelected && item.isEdit) {
    return renderSimpleRow([
      _todoName(item, dispatchFn),
      _deleteBtn(item, dispatchFn),
    ]);
  } else if (item.isSelected) {
    return renderSimpleRow([
      _checkBox(item, dispatchFn),
      _todoName(item, dispatchFn),
      _deleteBtn(item, dispatchFn),
    ]);
  } else {
    return renderUnselectedRow([
      _issuetype(item, dispatchFn),
      _priority(item, dispatchFn),
      _issueKey(item, dispatchFn),
      _todoName(item, dispatchFn),
      IssueStatusChip(item, dispatchFn),
    ]);
  }
}

Widget _renderReadOnlyTitle({
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

Widget _renderEditableTitle(item) => new StoreConnector<TodoAppState, Function>(
      converter: (store) =>
          (ListItemData d) => store.state.todos, // FIXME: implement action: (d) => d.withSelected(false)
      // .withTitle(value)
      builder: (context, onSubmit) {
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
            onSubmit(d);
          },
          onChanged: (String value) {
            _debug(context, 'onchanged: ' + value);
            // do not change the state here!!! The auto triggered re-rendering will cause serious perf/rendering issues
          },
          autofocus: true,

          // TextInputFormatters are applied in sequence.
          inputFormatters: [],
        );
      },
    );

Widget _renderDraggableItem(Widget child, ListItemData data, dispatchFn) => LongPressDraggable<ListItemData>(
      child: child,
      feedback: Text(
        'Dragged',
        style: TextStyle(fontSize: 15.0, color: Colors.white, decoration: TextDecoration.none),
      ),
      data: data,
      onDragStarted: dispatchFn(Actions.UnSelectAll()),
      childWhenDragging: Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: Divider(height: 2.0, color: Color.fromARGB(255, 255, 0, 0)),
      ),
      onDragCompleted: () => {},
    );

typedef Widget ItemWidget(ListItemData item, Function dispatchFn);

ItemWidget _deleteBtn = (item, dispatchFn) => IconButton(
      icon: Icon(Icons.delete),
      onPressed: dispatchFn(Actions.Delete(item)),
    );

ItemWidget _checkBox = (item, dispatchFn) => Checkbox(
      value: item.done,
      onChanged: (bool val) => dispatchFn(Actions.CbToggle(item))(),
    );

ItemWidget _issueKey = (item, dispatchFn) => Text(item.key);
ItemWidget _priority = (item, dispatchFn) => item.issue != null
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

ItemWidget _issuetype = (item, dispatchFn) => item.issue != null
    ? Image.network(ISSUE_TYPE_ICONS[item.issue.fields.issuetype.name] ?? ISSUE_TYPE_ICONS['Undefined'])
    : Text('');

ItemWidget _todoName = (item, dispatchFn) => Expanded(
      child: item.isEdit
          ? _renderEditableTitle(item)
          : item.isSelected
              ? _renderReadOnlyTitle(
                  item: item,
                  onTapCb: dispatchFn(Actions.Edit(item)),
                  onDoubleTapCb: dispatchFn(Actions.Edit(item)),
                )
              : _renderReadOnlyTitle(
                  item: item,
                  onTapCb: dispatchFn(Actions.Select(item)),
                  onDoubleTapCb: dispatchFn(Actions.Edit(item)),
                ),
    );

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

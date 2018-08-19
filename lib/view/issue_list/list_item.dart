import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/consts.dart';
import 'package:todo_flutter_app/view/issue_list/issue_status.dart';
import 'package:todo_flutter_app/state/domain.dart';

typedef Widget ItemWidget(ListItemData item, bool isCompact);

ItemWidget wDraggableListItem = (ListItemData item, isCompact) {
  return DragTarget<ListItemData>(
    // fixme:re-think keying! perf/ref?
    key: ObjectKey(item),
    onAccept: (dragged) => (dragged != item) ? dispatch(Actions.Drop(dragged, item)) : null,
    onWillAccept: (dragged) => true,
    builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
      final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
      final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

      return _renderHighlight(wListItem(item, isCompact));
    },
  );
};

ItemWidget wListItem = (ListItemData item, isCompact) {
  final isCompact = store.state.config.listViewMode == ListViewMode.COMPACT;

  final renderSimpleRow = (children) => Row(
        children: children,
      );
  final renderUnselectedRow = (children) => Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
  final renderUnselectedRowWithSwipeToggle = (children) => _wDraggableItem(
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => dispatch(Actions.CbToggle(item)),
          child: renderUnselectedRow(children),
        ),
        item,
      );

  if (item.isSelected && item.isEdit) {
    return renderSimpleRow([
      _wName(item, isCompact),
      _wDeleteBtn(item, isCompact),
    ]);
  } else if (item.isSelected) {
    return renderSimpleRow([
      _wCheckBox(item, isCompact),
      _wName(item, isCompact),
      _wDeleteBtn(item, isCompact),
    ]);
  } else {
    // fixme: rethink: only JiraIssue or manually created should processed here too?
    return renderUnselectedRow([
      isCompact ? Text('') : _wIssuetype(item, isCompact),
      _wPriority(item, isCompact),
      _wIssueKey(item, isCompact),
      _wName(item, isCompact),
      wIssueStatusChip(item, isCompact),
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

ItemWidget _wEditableTitle = (ListItemData item, isCompact) {
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

ItemWidget _wDeleteBtn = (item, isCompact) => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => dispatch(Actions.Delete(item)),
    );

ItemWidget _wCheckBox = (item, isCompact) => Checkbox(
      value: item.done,
      onChanged: (bool val) => dispatch(Actions.CbToggle(item)),
    );

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
      child: item.isEdit
          ? _wEditableTitle(item, isCompact)
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

import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/item/editable_item.dart';
import 'package:todo_flutter_app/view/issue_list/item/selected_item.dart';
import 'package:todo_flutter_app/view/issue_list/item/unselected_item.dart';

typedef Widget ItemWidget(ListItemData item, bool isCompact);

ItemWidget wListItem = (ListItemData item, isCompact) {
  final isCompact = store.state.config.listViewMode == ListViewMode.COMPACT;

  final renderUnselectedRowWithSwipeToggle = (children) => _wDraggableItem(
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => dispatch(Actions.CbToggle(item)),
          child: wUnselectedItem(item, isCompact),
        ),
        item,
      );

  if (item.isSelected && item.isEdit) {
    return wEditableItem(item, isCompact);
  } else if (item.isSelected) {
    return wSelectedItem(item, isCompact);
  } else {
    return wUnselectedItem(item, isCompact);
  }
};

ItemWidget wDraggableListItem = (ListItemData item, isCompact) {
  return DragTarget<ListItemData>(
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

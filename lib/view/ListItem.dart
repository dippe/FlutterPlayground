import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/action.dart' as Actions;
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

Widget ListItem(item, dispatchFn) {
  final bool isSelected = item.isSelected;
  final bool isEdit = item.isEdit;

  final deleteBtn = IconButton(
    icon: Icon(Icons.delete),
    onPressed: dispatchFn(Actions.Delete(item)),
  );

  final checkBox = Checkbox(
    value: item.done,
    onChanged: (bool val) => dispatchFn(Actions.CbToggle(item))(),
  );

  final todoName = Expanded(
    child: isEdit
        ? _renderEditableTitle(item)
        : isSelected
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
  final renderSimpleRow = (children) => Row(
        children: children,
      );
  final renderUnselectedRow = () => _renderDraggableItem(
        GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) => dispatchFn(Actions.CbToggle(item))(),
          child: Row(
            children: [
              item.done ? Icon(Icons.done) : Icon(Icons.arrow_right),
              todoName,
            ],
          ),
        ),
        item,
        dispatchFn,
      );

  if (isSelected && isEdit) {
    return renderSimpleRow([todoName, deleteBtn]);
  } else if (isSelected) {
    return renderSimpleRow([checkBox, todoName, deleteBtn]);
  } else {
    return renderUnselectedRow();
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

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

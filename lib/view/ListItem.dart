import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/action.dart' as Actions;
import 'package:todo_flutter_app/state/domain.dart';

Widget ListItem(TodoData todo, Function dispatchFn) {
  final bool isSelected = todo.isSelected;
  final bool isEdit = todo.isEdit;

  final deleteBtn = IconButton(
    icon: Icon(Icons.delete),
    onPressed: dispatchFn(Actions.Delete(todo)),
  );

  return DragTarget<TodoData>(
    onAccept: (dragged) {
      // returns void
      print('**** onAccept: ' + todo.title + ' >> ' + dragged.title);
      if (dragged != todo) {
        dispatchFn(Actions.Drop(dragged, todo))();
      }
    },
    onLeave: (dragged) {
      // returns void
      print('**** onLeave: ' + todo.title + ' >> ' + dragged.title);
    },
    onWillAccept: (dragged) {
      print('**** onWillAccept: ' + todo.title + ' >> ' + dragged.title);
      return true;
    },
    builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
      // todo: remove these 3 debugging lines later
//      TodoData rd = rejectedData.isNotEmpty ? rejectedData.first : null;
//      TodoData cd = candidateData.isNotEmpty ? candidateData.first : null;
//      print('**** build: ' + rd.toString() + ' ---- ' + cd.toString());

      final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
      final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

      final checkBox = Checkbox(
        value: todo.done,
        onChanged: (bool val) => dispatchFn(Actions.CbToggle(todo))(),
      );

      final todoName = Expanded(
        child: isEdit
            ? _renderEditableTitle(todo)
            : isSelected
                ? _renderReadOnlyTitle(
                    todo: todo,
                    onTapCb: dispatchFn(Actions.Edit(todo)),
                    onDoubleTapCb: dispatchFn(Actions.Edit(todo)),
                  )
                : _renderReadOnlyTitle(
                    todo: todo,
                    onTapCb: dispatchFn(Actions.Select(todo)),
                    onDoubleTapCb: dispatchFn(Actions.Edit(todo)),
                  ),
      );
      final renderSimpleRow = (children) => Row(
            children: children,
          );
      final renderUnselectedRow = () => _renderDraggableTodo(
            GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) => dispatchFn(Actions.CbToggle(todo))(),
              child: Row(
                children: [
                  todo.done ? Icon(Icons.done) : Icon(Icons.arrow_right),
                  todoName,
                ],
              ),
            ),
            todo,
            dispatchFn,
          );

      if (isSelected && isEdit) {
        return renderSimpleRow([todoName, deleteBtn]);
      } else if (isSelected) {
        return renderSimpleRow([checkBox, todoName, deleteBtn]);
      } else {
        return _renderHighlight(renderUnselectedRow());
      }
    },
  );
}

Widget _renderReadOnlyTitle({@required TodoData todo, @required Function onTapCb, @required Function onDoubleTapCb}) {
  // the actual substate is the proper tododata (see the PropertyManager)
  return InkWell(
    onDoubleTap: onDoubleTapCb,
    onTap: onTapCb,
    // todo: kell ez a container?
    child: Container(
      padding: new EdgeInsets.all(10.0),
      // color: new Color(0X9900CCCC),
      child: Text(
        todo.title,
        style: TextStyle(decoration: todo.done ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    ),
  );
}

Widget _renderEditableTitle(todo) => new StoreConnector<TodoAppState, Function>(
      converter: (store) => (TodoData d) => store.state.todos, // FIXME: implement action: (d) => d.withSelected(false)
      // .withTitle(value)
      builder: (context, onSubmit) {
        final d = todo;
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

Widget _renderDraggableTodo(Widget child, TodoData data, dispatchFn) => LongPressDraggable<TodoData>(
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

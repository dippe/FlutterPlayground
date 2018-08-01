import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';

Widget renderTodoItem(
  TodoData todo,
  Function onDelete,
  Function onTapCb,
  Function onDoubleTapCb,
  Function onItemDrop,
) {
  // fixme: move "selected" into the todo item from the list view
  final bool isSelected = todo.isSelected;
  final bool isEdit = todo.isEdit;

  final deleteBtn = IconButton(
    icon: Icon(Icons.delete),
    onPressed: onDelete,
  );

  return DragTarget<TodoData>(
    onAccept: (dragged) {
      // returns void
      print('**** onAccept: ' + todo.title + ' >> ' + dragged.title);
      if (dragged != todo) {
        onItemDrop(dragged, todo);
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
      TodoData rd = rejectedData.isNotEmpty ? rejectedData.first : null;
      TodoData cd = candidateData.isNotEmpty ? candidateData.first : null;
      print('**** build: ' + rd.toString() + ' ---- ' + cd.toString());

      final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
      final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

      final checkBox = Checkbox(
        value: todo.done,
        // FIXME: re-enable
        onChanged: (bool val) {},
//              onChanged: (bool val) => state.change((d) => d.withToggled()),
      );

      final todoName = Expanded(
        child: isEdit
            ? _renderEditableTitle(todo)
            : isSelected
                ? _renderReadOnlyTitle(todo, onDoubleTapCb, onDoubleTapCb) // if selected, one tap is enough to edit
                : _renderReadOnlyTitle(todo, onTapCb, onDoubleTapCb),
      );

      final renderEditRow = () => Row(
            children: [
              todoName,
              deleteBtn,
            ],
          );
      final renderSelectedRow = () => Row(
            children: [
              checkBox,
              todoName,
              deleteBtn,
            ],
          );
      final renderUnselectedRow = () => _renderDraggableTodo(
            GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                // FIXME: re-enable
//                state.change((d) => d.withToggled());
              },
              child: Row(
                children: [
                  todo.done ? Icon(Icons.done) : Icon(Icons.arrow_right),
                  todoName,
                ],
              ),
            ),
            todo,
          );

      final row = isSelected && isEdit ? renderEditRow() : (isSelected ? renderSelectedRow() : renderUnselectedRow());

      return _renderHighlight(row);
    },
  );
}

Widget _renderReadOnlyTitle(TodoData todo, Function onTapCb, Function onDoubleTapCb) {
  // the actual substate is the proper tododata (see the PropertyManager)
  return InkWell(
    onDoubleTap: () => onDoubleTapCb(todo),
    onTap: () => onTapCb(todo),
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

Widget _renderDraggableTodo(Widget child, TodoData data) => LongPressDraggable<TodoData>(
      child: child,
      feedback: Text(
        'Dragged',
        style: TextStyle(fontSize: 15.0, color: Colors.white, decoration: TextDecoration.none),
      ),
      data: data,
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

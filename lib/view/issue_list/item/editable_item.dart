import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';

ItemWidget wEditableItem = (ListItemData item, isCompact) {
  return Row(children: [
    _wName(item, isCompact),
    _wDeleteBtn(item, isCompact),
  ]);
};

ItemWidget _wName = (item, isCompact) => Expanded(child: _wEditableTitle(item, isCompact));

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

ItemWidget _wDeleteBtn = (item, isCompact) => IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => dispatch(Actions.Delete(item)),
    );

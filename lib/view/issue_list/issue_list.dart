import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/item/list_item.dart';

// the progress indicator cannot be rendered outside because the flutter crashes when adding a new column / etc
// wrapper to this
Widget wIssueList(List<ListItemData> issues, bool isCompact) => Scrollbar(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: issues.map((item) => wDraggableListItem(item, isCompact)).toList(),
      ),
    );

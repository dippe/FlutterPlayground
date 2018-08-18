import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/list_item.dart';

// the progress indicator cannot be rendered outside because the flutter crashes when adding a new column / etc
// wrapper to this
Widget wIssueList(List<ListItemData> issues, bool showProgressIndicator) => ListView(
      scrollDirection: Axis.vertical,
      children: issues.map((item) => wDraggableListItem(item)).toList()
        ..insert(
          0,
          new SizedBox(
            height: 3.0,
            child: showProgressIndicator ? new LinearProgressIndicator() : null,
          ),
        ),
    );

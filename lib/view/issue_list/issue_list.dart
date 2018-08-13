import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/list_item.dart';

Widget wIssueList(List<ListItemData> issues) => ListView(
      scrollDirection: Axis.vertical,
      children: issues.map((item) => wDraggableListItem(item)).toList(),
    );

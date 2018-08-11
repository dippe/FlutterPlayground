import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/util/types.dart';

// Action DTO-s

class Add implements Action {
  JiraIssue issue;

  Add(this.issue);

  @override
  String toString() {
    return 'Add{issue: $issue}';
  }
}

class Delete implements Action {
  ListItemData item;

  Delete(this.item);

  @override
  String toString() {
    return 'Delete{item: $item}';
  }
}

class Drag implements Action {
  ListItemData item;

  Drag(this.item);

  @override
  String toString() {
    return 'Drag{item: $item}';
  }
}

class Drop implements Action {
  ListItemData dragged;
  ListItemData target;

  Drop(this.dragged, this.target);

  @override
  String toString() {
    return 'Drop{dragged: $dragged, target: $target}';
  }
}

class Select implements Action {
  ListItemData item;

  Select(this.item);

  @override
  String toString() {
    return 'Select{item: $item}';
  }
}

class UnSelectAll implements Action {}

class Edit implements Action {
  ListItemData item;

  Edit(this.item);

  @override
  String toString() {
    return 'Edit{item: $item}';
  }
}

class CbToggle implements Action {
  ListItemData item;

  CbToggle(this.item);

  @override
  String toString() {
    return 'SwipeToggle{item: $item}';
  }
}

class SetItemTitle implements Action {
  String key;
  String title;

  SetItemTitle(this.key, this.title);

  @override
  String toString() {
    return 'SetItemTitle{key: $key title: $title}';
  }
}

import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/state/domain.dart';

// Action DTO-s

abstract class Action {}

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

class ShowLoginDialog implements Action {
  bool show;

  ShowLoginDialog(this.show);

  @override
  String toString() {
    return 'ShowLoginDialog{show: $show}';
  }
}

class SetUserName implements Action {
  String name;

  SetUserName(this.name);

  @override
  String toString() {
    return 'SetUserName{name: $name}';
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

class SetPwd implements Action {
  String pwd;

  SetPwd(this.pwd);

  @override
  String toString() {
    return 'SetPwd{pwd: $pwd}';
  }
}

class Login implements Action {
  Login();

  @override
  String toString() {
    return 'Login{}';
  }
}

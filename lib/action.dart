import 'package:todo_flutter_app/state/domain.dart';

// Action DTO-s

abstract class Action {}

class Add implements Action {
  String name;

  Add(this.name);

  @override
  String toString() {
    return 'Add{name: $name}';
  }
}

class Delete implements Action {
  TodoData item;

  Delete(this.item);

  @override
  String toString() {
    return 'Delete{item: $item}';
  }
}

class Drag implements Action {
  TodoData item;

  Drag(this.item);

  @override
  String toString() {
    return 'Drag{item: $item}';
  }
}

class Drop implements Action {
  TodoData dragged;
  TodoData target;

  Drop(this.dragged, this.target);

  @override
  String toString() {
    return 'Drop{dragged: $dragged, target: $target}';
  }
}

class Select implements Action {
  TodoData item;

  Select(this.item);

  @override
  String toString() {
    return 'Select{item: $item}';
  }
}

class UnSelectAll implements Action {}

class Edit implements Action {
  TodoData item;

  Edit(this.item);

  @override
  String toString() {
    return 'Edit{item: $item}';
  }
}

class CbToggle implements Action {
  TodoData item;

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

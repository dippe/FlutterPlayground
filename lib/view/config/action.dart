import 'package:todo_flutter_app/util/types.dart';

// Action DTO-s

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

class HideLoginDialog implements Action {
  HideLoginDialog();

  @override
  String toString() {
    return 'Login{}';
  }
}

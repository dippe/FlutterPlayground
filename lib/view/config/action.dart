import 'package:todo_flutter_app/util/types.dart';

// Action DTO-s

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

class SetBaseUrl implements Action {
  String url;

  SetBaseUrl(this.url);

  @override
  String toString() {
    return 'SetBaseUrl{url: $url}';
  }
}

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

class SetMaxJqlIssueNum implements Action {
  String num;

  SetMaxJqlIssueNum(this.num);

  @override
  String toString() {
    return 'SetMaxJqlIssueNum{$num}';
  }
}

class SetMaxIssueKeyLength implements Action {
  String num;

  SetMaxIssueKeyLength(this.num);

  @override
  String toString() {
    return 'SetMaxIssueKeyLength{$num}';
  }
}

class SetRecentIssueCommentsNum implements Action {
  String num;

  SetRecentIssueCommentsNum(this.num);

  @override
  String toString() {
    return 'SetRecentIssueCommentsNum{num: $num}';
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

class ToggleDisplayModeAction implements Action {}

import 'package:todo_flutter_app/util/types.dart';

class ShowMessagesAction implements Action {}

class HideMessagesAction implements Action {}

class AddErrorMessageAction implements Action {
  final String text;

  AddErrorMessageAction(this.text);
}

class AddWarningMessageAction implements Action {
  final String text;

  AddWarningMessageAction(this.text);
}

class AddInfoMessageAction implements Action {
  final String text;

  AddInfoMessageAction(this.text);
}

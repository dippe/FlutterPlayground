import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/util/types.dart';

class ShowMessagesAction implements Action {}

class HideMessagesAction implements Action {}

class AddMessageAction implements Action {
  final AppMessage message;

  AddMessageAction(this.message);
}

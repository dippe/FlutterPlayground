import 'package:todo_flutter_app/util/types.dart';

class DoSearchAction implements Action {
  final String text;

  DoSearchAction(this.text);

  @override
  String toString() {
    return this.runtimeType.toString() + '{text: $text}';
  }
}

import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/util/types.dart';

class SetFilterNameAction implements Action {
  final String name;

  SetFilterNameAction(this.name);

  @override
  String toString() {
    return this.runtimeType.toString() + '{name: $name}';
  }
}

class SelectFilterAction implements Action {
  final JiraFilter filter;

  SelectFilterAction(this.filter);

  @override
  String toString() {
    return 'SelectFilterAction{filter: $filter}';
  }
}

import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/util/types.dart';

class SetName implements Action {
  final String name;

  SetName(this.name);

  @override
  String toString() {
    return 'SetName{name: $name}';
  }
}

class SelectFilter implements Action {
  final JiraFilter filter;

  SelectFilter(this.filter);

  @override
  String toString() {
    return 'SelectFilter{filter: $filter}';
  }
}

import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/util/tripledes/lib/tripledes.dart';
import 'package:todo_flutter_app/view/config/action.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;
import 'package:todo_flutter_app/view/messages/action.dart';

Reducer<ConfigState> configReducer = (ConfigState state, dynamic action) {
  if (action is Actions.SetUserName) {
  } else {
    return state;
  }
};


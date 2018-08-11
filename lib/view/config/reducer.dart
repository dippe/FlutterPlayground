import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;

Reducer<ConfigState> configReducer = (ConfigState state, dynamic action) {
  if (action is Actions.SetUserName) {
    return state.copyWith(user: action.name);
  } else if (action is Actions.SetPwd) {
    return state.copyWith(password: action.pwd);
  } else {
    print("configReducer: unhandled action type: " + action.runtimeType.toString());
    return state;
  }
};

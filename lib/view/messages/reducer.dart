import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/messages/action.dart';

Reducer<ViewState> messagesReducer = combineReducers<ViewState>([
  debugReducer<ViewState>('messagesReducer'),
  TypedReducer<ViewState, ShowMessagesAction>(_show),
  TypedReducer<ViewState, HideMessagesAction>(_hide),
  TypedReducer<ViewState, AddMessageAction>(_add),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _show(ViewState state, ShowMessagesAction action) {
  return state.copyWith(messages: state.messages.copyWith(visible: true));
}

ViewState _hide(ViewState state, HideMessagesAction action) {
  return state.copyWith(messages: state.messages.copyWith(visible: false));
}

ViewState _add(ViewState state, AddMessageAction action) {
  // fixme: mutable
  return state.copyWith(messages: state.messages.copyWith(messages: state.messages.messages..add(action.message)));
}

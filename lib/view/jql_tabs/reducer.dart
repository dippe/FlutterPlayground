import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';

/*
 *
 * All of the view reducers are working on the actually selected list view!!
 * So the actual item list is extracted using the current state's actually selected list idx.
 *
 */
typedef List<ListItemData> ListModifierFn(List<ListItemData> l);

Reducer<ViewState> jqlTabsReducer = combineReducers<ViewState>([]);

/* **********************
*
*    Reducer functions
*
* ***********************/

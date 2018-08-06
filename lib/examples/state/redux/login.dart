import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';
import 'package:todo_flutter_app/examples/state/redux/action.dart' as Actions;
import 'package:todo_flutter_app/examples/state/redux/state/state.dart';

var renderLoginForm = new Column(
  children: <Widget>[
    Title(
      color: Colors.greenAccent,
      title: 'Login',
      child: Text('JIRA Login'),
    ),
    const Divider(
      height: 1.0,
    ),
    new ListTile(
      leading: const Icon(Icons.person),
      title: _Name(),
    ),
    new ListTile(
      leading: const Icon(Icons.account_box),
      title: _Pwd(),
    ),
    new ListTile(
      leading: const Icon(Icons.email),
      title: new TextField(
        decoration: new InputDecoration(
          hintText: "Email",
        ),
      ),
    ),
    _renderOkBtn,
  ],
);

class _Name extends StatefulWidget {
  @override
  _NameState createState() => new _NameState();
}

class _NameState extends State<_Name> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<TodoAppState, Function>(
      distinct: true,
      converter: dispatchConverter,
      builder: (context, dispatchFn) => new TextField(
            controller: _controller,
            decoration: new InputDecoration(labelText: 'Name'),
            onSubmitted: (txt) {
              dispatchFn(Actions.SetUserName(txt))();
//              _controller.text = '';
            },
          ),
    );
  }
}

class _Pwd extends StatefulWidget {
  @override
  _PwdState createState() => new _PwdState();
}

class _PwdState extends State<_Pwd> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<TodoAppState, Function>(
      distinct: true,
      converter: dispatchConverter,
      builder: (context, dispatchFn) => new TextField(
            controller: _controller,
            decoration: new InputDecoration(labelText: 'Pwd'),
            onSubmitted: (txt) {
              dispatchFn(Actions.SetPwd(txt))();
//              _controller.text = txt;
            },
          ),
    );
  }
}

Widget _renderOkBtn = StoreConnector<TodoAppState, Function>(
  distinct: true,
  converter: dispatchConverter,
  builder: (context, dispatchFn) => new FlatButton(
        child: Text('Ok-Mok'),
        onPressed: () => dispatchFn(Actions.Login())(),
      ),
);

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/action.dart' as Actions;
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';

Widget LoginForm() => new StoreConnector<TodoAppState, LoginData>(
      converter: (state) => state.state.login,
      builder: (context, user) => new Column(
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
                title: _Name(user.user),
              ),
              new ListTile(
                leading: const Icon(Icons.account_box),
                title: _Pwd(user.password),
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
          ),
    );

class _Name extends StatefulWidget {
  String txt;

  _Name(this.txt);

  @override
  _NameState createState() => _NameState(txt);
}

class _NameState extends State<_Name> {
  TextEditingController _controller;

  _NameState(String initTxt) {
    _controller = new TextEditingController(text: initTxt);
  }

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
  String txt;

  _Pwd(this.txt);

  @override
  _PwdState createState() => new _PwdState(txt);
}

class _PwdState extends State<_Pwd> {
  TextEditingController _controller;

  _PwdState(String initTxt) {
    _controller = new TextEditingController(text: initTxt);
  }

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

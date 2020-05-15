import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:webview_flutter/webview_flutter.dart';

//const testBaseUrl = 'https://jsonplaceholder.typicode.com';
const testBaseUrl = 'https://index.hu';

JavascriptChannel _jiraJavascriptChannel() {
  return JavascriptChannel(
      name: 'Jira',
      onMessageReceived: (JavascriptMessage jsMessage) {
        String msgStr = jsMessage.message;
        var res = jsonDecode(msgStr);
        print('JIRA channel msg: ' + msgStr);
      });
}

JavascriptChannel _logJavascriptChannel() {
  return JavascriptChannel(
      name: 'Log',
      onMessageReceived: (JavascriptMessage jsMessage) {
        String msgStr = jsMessage.message;
        print('log channel msg: ' + msgStr);

//        Scaffold.of(context).showSnackBar(
//          SnackBar(content: Text(msgStr)),
//        );
      });
}

// fixme: implement escaping of jql string
// fixme: accept language
void _onFetchJira(Future<WebViewController> controller, String jql) {
  controller.then((controller) => controller.evaluateJavascript('''
   Promise.race([
        fetch('https://xy.hu/users'),
        new Promise((_, reject) =>
            setTimeout(() => reject(new Error('timeout')), 10)
        )
        .then((response) {
          Log.postMessage('response arrived')
          Log.postMessage('response :', response)
          return response;
        )
        .then(response => JSON.stringify(response))
        .then(data => Jira.postMessage(data))
        .catch((err) => Log.postMessage('JS FETCH ERROR', err));
      Log.postMessage('FETCH started ...')
  ''').whenComplete(() {
        print('complete');
      }).catchError((e) {
        print("inside catchError");
        print(e.error);
      }));
  return;
  controller.then((controller) {
    print('CONTROLLER: ');
    return controller.evaluateJavascript('''fetch("$jql", {
    "headers": {
    "accept": "application/json, application/vnd-ms-excel",
    "accept-language": "en-US,en;q=0.9,hu;q=0.8",
    "content-type": "application/json",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin"
    },
    "referrerPolicy": "no-referrer-when-downgrade",
    "body": null,
    "method": "GET",
    "mode": "cors",
    "credentials": "include"
    })
        .then(response => response.json())
        .then(response => {...response}.origJql="$jql")
        .then(response => JSON.stringify(response))
        .then(data => Jira.postMessage(data))
    .catch(response => response);
    Jira.postMessage('Tesztecske');
  ''');
  });
}

Widget wWVPage() {
  return new StoreConnector<AppState, ConfigState>(
      rebuildOnChange: false,
      distinct: true,
      ignoreChange: (AppState c) => true,
      converter: (store) => store.state.config,
//      builder: (context, config) => WebViewContainer('https://hup.hu'),
//  );
//}
      builder: (context, config) {
        return wvSingleton();
      });
}

WebView singleton = null;
final Completer<WebViewController> _controller = Completer<WebViewController>();

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

wvSingleton() {
  if (singleton == null) {
    singleton = WebView(
      key: UniqueKey(),
      initialUrl:
          testBaseUrl.isNotEmpty ? testBaseUrl : store.state.config.baseUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        if (!_controller.isCompleted) {
          _controller.complete(webViewController);
        }
      },
      javascriptChannels: <JavascriptChannel>[
        _jiraJavascriptChannel(),
        _logJavascriptChannel()
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
//        _onFetchJira(
//            _controller.future, 'https://jira.epam.com/jira/rest/api/2/myself');
        print('fetch started: ****');
      },
      gestureNavigationEnabled: true,
    );
  }

  return singleton;
}

//class WebViewContainer extends StatefulWidget {
//  final url;
//
//  WebViewContainer(this.url);
//
//  @override
//  createState() => _WebViewContainerState(this.url);
//}

//class _WebViewContainerState extends State<WebViewContainer>  with AutomaticKeepAliveClientMixin {
//  var _url;
//  final _key = UniqueKey();
//
//  _WebViewContainerState(this._url);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(),
//        body: Column(
//          children: [
//            Expanded(
//                child: WebView(
//              key: _key,
//              javascriptMode: JavascriptMode.unrestricted,
//              initialUrl: this._url,
//              onWebViewCreated: (WebViewController webViewController) {
//                _controller.complete(webViewController);
//              },
//            )),
//            Text('asfdasda')
//          ],
//        ));
//  }
//
//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
//}

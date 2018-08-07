import 'package:todo_flutter_app/util/auth.dart';

const TMP_USER = "dippenexus@gmail.com";
const TMP_PWD = "KGRCC7h58fgfwKO3ZjKN62C9";
const BASE_URL = "https://testdev1.atlassian.net";

var getIssue = (String key) {
  var client = BasicAuthClient(TMP_USER, TMP_PWD);
  var response = client.get(BASE_URL + "/rest/api/2/issue/" + key);
  response.then((val) => print(val.body));
};

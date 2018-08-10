// fixme: check for different response types! this is tested only with JQL search!
class JiraErrorMsg {
  final List<String> errorMessages;
  final List<String> warningMessages;

  JiraErrorMsg.fromJson(Map<String, dynamic> json)
      : errorMessages = List<String>.from(json['errorMessages']),
        warningMessages = List<String>.from(json['warningMessages']);
}

// fixme: check for different response types! this is tested only with JQL search!
class JiraErrorMsg {
  final List<String> errorMessages;
  final Map<String, String> errors;

  JiraErrorMsg.fromJson(Map<String, dynamic> json)
      : errorMessages = List<String>.from(json['errorMessages']),
        errors = Map<String, String>.from(json['errors']);
}

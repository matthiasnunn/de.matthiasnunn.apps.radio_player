import 'poll.dart';


class Auth {

  final String login;
  final Poll poll;

  Auth(this.login, this.poll);

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      json["login"],
      Poll.fromJson(json["poll"])
    );
  }
}

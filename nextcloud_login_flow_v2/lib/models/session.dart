class Session {

  final String appPassword;
  final String loginName;
  final String server;

  Session(this.appPassword, this.loginName, this.server);

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      json["appPassword"],
      json["loginName"],
      json["server"]
    );
  }
}

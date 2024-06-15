class Instance {

  final String host;
  final String name;
  final String password;
  final String user;

  Instance({required this.host, required this.name, required this.password, required this.user});

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      host: json["host"],
      name: json["name"],
      password: json["password"],
      user: json["user"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "host": host,
      "name": name,
      "password": password,
      "user": user
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Instance &&
           other.host == host &&
           other.name == name &&
           other.password == password &&
           other.user == user;
  }

  @override
  int get hashCode => host.hashCode ^ name.hashCode ^ password.hashCode ^ user.hashCode;
}

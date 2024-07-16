class Poll {

  final String endpoint;
  final String token;

  Poll(this.endpoint, this.token);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      json["endpoint"],
      json["token"]
    );
  }
}

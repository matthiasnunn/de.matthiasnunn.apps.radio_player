class Radio {

  final String name;
  final String streamUrl;

  Radio({required this.name, required this.streamUrl});

  factory Radio.fromJson(Map<String, dynamic> json) {
    return Radio(
      name: json["name"],
      streamUrl: json["stream_url"]
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Radio &&
        other.name == name &&
        other.streamUrl == streamUrl;
  }

  @override
  int get hashCode => name.hashCode ^ streamUrl.hashCode;
}

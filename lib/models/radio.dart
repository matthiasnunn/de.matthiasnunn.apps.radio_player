import 'dart:convert';

import 'package:http/http.dart';
import 'package:radio_player/models/instance.dart';
import 'package:url_builder/url_builder.dart';


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

  static Future<List<Radio>> getRadiosFor(Instance instance) async {
    final encodedCredentials = base64.encode(utf8.encode("${instance.user}:${instance.password}"));
    final headers = {
      "Accept": "application/json",
      "Authorization": "Basic $encodedCredentials"
    };
    final url = Uri.parse(urlJoin(instance.host, "index.php/apps/music/api/radio"));
    final response = await get(url, headers: headers);
    final list = json.decode(response.body) as List<dynamic>;
    return list.map((el) => Radio.fromJson(el)).toList();
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

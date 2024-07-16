import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextcloud_login_flow_v2/models/session.dart';
import 'package:radio_player/models/radio.dart';
import 'package:url_builder/url_builder.dart';


class Api {

  static Future<List<Radio>> getRadiosFor(Session session) async {
    final encodedCredentials = base64.encode(utf8.encode("${session.loginName}:${session.appPassword}"));
    final headers = {
      "Accept": "application/json",
      "Authorization": "Basic $encodedCredentials"
    };
    final url = Uri.parse(urlJoin(session.server, "index.php/apps/music/api/radio"));
    final response = await get(url, headers: headers);
    final list = json.decode(response.body) as List<dynamic>;
    return list.map((el) => Radio.fromJson(el)).toList();
  }
}

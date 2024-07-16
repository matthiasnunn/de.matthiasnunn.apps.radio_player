import 'package:flutter/cupertino.dart';
import 'package:nextcloud_login_flow_v2/nextcloud_login_flow_v2.dart';
import 'package:radio_player/models/radio.dart';
import 'package:radio_player/services/api.dart';
import 'package:radio_player/services/session.dart';


class ApiClient {

  static Future<List<Radio>> getRadios(BuildContext context) async {
    var session = await Session.read();
    if (session == null) {
      session = await Nextcloud.loginFlowV2(context);
      await Session.write(session);
    }
    return await Api.getRadiosFor(session);
  }

  static Future<void> logout() async {
    await Session.delete();
  }
}

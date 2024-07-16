import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nextcloud_login_flow_v2/models/session.dart' as nextcloud;


class Session {

  static const _session = "session";

  static const _storage = FlutterSecureStorage();

  static Future<void> delete() async {
    await _storage.delete(key: _session);
  }

  static Future<nextcloud.Session?> read() async {
    final string = await _storage.read(key: _session);
    if (string == null) {
      return null;
    }
    return json.decode(string) as nextcloud.Session;  // TODO: alternativ Session.fromJson -> nötig?  =>  funktioniert diese Zeile???
  }

  static Future<void> write(nextcloud.Session session) async {
    final jsonString = json.encode(session);
    await _storage.write(key: _session, value: jsonString);
  }
}

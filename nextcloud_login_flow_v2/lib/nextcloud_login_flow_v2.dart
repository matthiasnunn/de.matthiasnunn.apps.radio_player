library nextcloud_login_flow_v2;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:nextcloud_login_flow_v2/models/auth.dart';
import 'package:nextcloud_login_flow_v2/models/session.dart';
import 'package:nextcloud_login_flow_v2/utils/host_input_dialog.dart';


class Nextcloud {

  // https://docs.nextcloud.com/server/latest/developer_manual/client_apis/LoginFlow/index.html

  static Future<Session> loginFlowV2(BuildContext context) async {
    final Auth auth = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HostInputDialog();
      }
    );

    // await launchUrl(Uri.parse(auth.login));
    Session? session;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri.uri(Uri.parse(auth.login))
          ),
          onExitFullscreen: (_) async {
            session = await _checkSessionResponse(auth);
          }
        );
      }
    );

    if (session == null) {
      throw Exception("Fehler");
    }

    return session!;
  }

  static Future<Session?> _checkSessionResponse(Auth auth) async {
    final uri = Uri.parse("${auth.poll.endpoint}?token=${auth.poll.token}");
    final response = await post(uri);
    if (response.statusCode == 200) {
      return Session.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 404) {
      return null;
    }
    return null;
  }
}

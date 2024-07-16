import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart';
import 'package:nextcloud_login_flow_v2/models/auth.dart';


class HostInputDialog extends StatefulWidget {

  const HostInputDialog({super.key});

  @override
  State<HostInputDialog> createState() => _HostInputDialogState();
}


class _HostInputDialogState extends State<HostInputDialog> {

  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();

  String? _error;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.transparent,
          secondary: Colors.transparent,
          onSecondary: Colors.transparent,
          error: Colors.white,
          onError: Colors.white,
          surface: Color.fromRGBO(0, 130, 201, 1),
          onSurface: Colors.white
        //outlineVariant ....
        )
      ),
      child: Dialog.fullscreen(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: SvgPicture.asset(
                  "assets/nextcloud_logo.svg",
                  color: Colors.white,
                  package: "nextcloud_login_flow_v2"
                )
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: _hostController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        errorText: _error,
                        labelText: "Serveradresse https://...",
                        suffixIcon: Align(
                          heightFactor: 1.0,
                          widthFactor: 1.25,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: _validateHost
                          )
                        )
                      ),
                      onFieldSubmitted: (_) => _validateHost(),
                      validator: ValidationBuilder(requiredMessage: "Bitte einen Host angeben").url("Keine gültige URL").build()
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  Future<void> _validateHost() async {
    if (_formKey.currentState!.validate()) {
      final input = Uri.parse(_hostController.text);
      final uri = Uri(
        scheme: "https",
        host: input.host,
        port: input.port,
        pathSegments: [
          input.path,
          "index.php",
          "login",
          "v2"
        ]
      );
      try {
        final response = await post(uri);
        final auth = Auth.fromJson(json.decode(response.body));
        if (context.mounted) {
          Navigator.pop(context, auth);
        }
      } on ClientException {
        setState(() {
          _error = "Konnte den Host nicht finden";
        });
      } on Exception {
        setState(() {
          _error = "Unbekannter Fehler";
        });
      }
    }
  }
}

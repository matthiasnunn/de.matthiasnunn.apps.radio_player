import 'package:flutter/material.dart';
import 'package:radio_player/db/instances.dart';
import 'package:radio_player/models/instance.dart';


class InstanceInputDialog extends StatefulWidget {

  const InstanceInputDialog({super.key});

  @override
  State<InstanceInputDialog> createState() => _InstanceInputDialogState();
}


class _InstanceInputDialogState extends State<InstanceInputDialog> {

  var _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Name"
                      ),
                      validator: _notEmpty
                    ),
                    Container(height: 32),
                    TextFormField(
                      controller: _hostController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "https://nextcloud.example.org",
                        labelText: "Host"
                      ),
                      validator: _notEmpty
                    ),
                    Container(height: 32),
                    TextFormField(
                      controller: _userController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Benutzer"
                      ),
                      validator: _notEmpty
                    ),
                    Container(height: 32),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Passwort",
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _passwordVisible = !_passwordVisible);
                          }
                        )
                      ),
                      enableInteractiveSelection: true,  // allow paste
                      obscureText: _passwordVisible,
                      validator: _notEmpty
                    )
                  ]
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Abbrechen")
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    onPressed: _onPressed,
                    child: const Text("Speichern")
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }

  String? _notEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "Bitte Text eingeben";
    }
    return null;
  }

  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {
      final instance = Instance(
        host: _hostController.text,
        name: _nameController.text,
        password: _passwordController.text,
        user: _userController.text
      );
      await Instances.setInstances(instance);
      if (context.mounted) {
        Navigator.pop(context, instance);
      }
    }
  }
}

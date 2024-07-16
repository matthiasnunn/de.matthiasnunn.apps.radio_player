import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_player/main.dart';
import 'package:radio_player/models/radio.dart' as custom;
import 'package:radio_player/widgets/player.dart';
import 'package:radio_player/widgets/radio_view.dart';


class PlayerPage extends StatefulWidget {

  final _player = audioHandler;

  PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}


class _PlayerPageState extends State<PlayerPage> {

  custom.Radio? _radio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ownCloud Music Radio"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout
          )
        ]
      ),
      body: Column(
        children: [
          Expanded(
            child: RadioView(
              onRadioSelect: (custom.Radio radio) async {
                setState(() => _radio = radio);
                // TODO: die folgenden drei Zeilen können theoretisch nach
                // `player.dart`. Es gibt nur das Problem, dass `initState`
                // nicht bei einem Wechsel der Radiostation aufgerufen wird.
                final audioSource = AudioSource.uri(Uri.parse(_radio!.streamUrl));
                await widget._player.setAudioSource(audioSource);
                await widget._player.play();
              },
              selectedRadio: _radio
            )
          ),
          if (_radio != null)
            Player(
              onRemove: () => setState(() => _radio = null),
              player: widget._player,
              radio: _radio!
            )
        ]
      )
    );
  }

  _logout() {
    // TODO: logout + wollen sie sich wirklich ausloggen?
    // TODO: close dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("My title"),
          content: Text("This is my message."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () { },
            ),
            TextButton(
              child: Text("lal"),
              onPressed: () {}
            )
          ]
        );
      }
    );
  }
}

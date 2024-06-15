import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_player/db/instances.dart';
import 'package:radio_player/main.dart';
import 'package:radio_player/models/instance.dart';
import 'package:radio_player/models/radio.dart' as custom;
import 'package:radio_player/widgets/instances_drawer.dart';
import 'package:radio_player/widgets/player.dart';
import 'package:radio_player/widgets/radio_view.dart';


class PlayerPage extends StatefulWidget {

  final _player = audioHandler;

  PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}


class _PlayerPageState extends State<PlayerPage> {

  Instance? _instance;
  custom.Radio? _radio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ownCloud Music Radio")
      ),
      body: Column(
        children: [
          Expanded(
            child: RadioView(
              instance: _instance,
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
      ),
      drawer: InstancesDrawer(
        onInstanceChange: (Instance? instance) async {
          await Instances.setLastInstance(instance);
          setState(() => _instance = instance);
        },
        selectedInstance: _instance
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAndSetLastInstance();
  }

  Future<void> _loadAndSetLastInstance() async {
    final instance = await Instances.getLastInstance();
    if (instance != null) {
      setState(() {
        _instance = instance;
      });
    }
  }
}

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio_player/models/radio.dart' as custom;
import 'package:radio_player/utils/my_audio_handler.dart';
import 'package:radio_player/widgets/double_stream_builder.dart';
import 'package:radio_player/widgets/marquee.dart';


class Player extends StatefulWidget {

  final Function() onRemove;
  final MyAudioHandler player;
  final custom.Radio radio;

  const Player({super.key, required this.onRemove, required this.player, required this.radio});

  @override
  State<Player> createState() => _PlayerState();
}


class _PlayerState extends State<Player> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<State<Player>>(this),
      onDismissed: (_) {
        widget.player.stop();
        widget.onRemove();
      },
      child: Card(
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DoubleStreamBuilder(
                stream1: widget.player.bufferingStream,
                stream2: widget.player.playingStream,
                builder: (context, snapshot1, snapshot2) {
                  if (snapshot1.hasData && snapshot2.hasData) {
                    final isBuffering = snapshot1.data!;
                    if (isBuffering) {
                      return InkWell(
                        onTap: () async {
                          await widget.player.play();
                        },
                        child: const CircularProgressIndicator()
                      );
                    }
                    final isPlaying = snapshot2.data!;
                    if (isPlaying) {
                      return IconButton(
                        icon: const Icon(Icons.pause, size: 32),
                        onPressed: () async {
                          await widget.player.pause();
                        }
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.play_arrow, size: 32),
                      onPressed: () async {
                        await widget.player.play();
                      }
                    );
                  }
                  return Container();
                }
              ),
              Container(
                width: 24
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.radio.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(height: 10),
                    StreamBuilder<IcyMetadata?>(
                      stream: widget.player.icyMetadataStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final title = snapshot.data?.info?.title?.isEmpty ?? true ? "Die Informationen sind aktuell noch nicht verfügbar!" : snapshot.data!.info!.title!;
                          widget.player.setMediaItem(
                            MediaItem(
                              artist: title,
                              id: widget.radio.streamUrl,
                              title: widget.radio.name
                            )
                          );
                          return Marquee(
                            child: Text(title)
                          );
                        }
                        if (snapshot.hasError) {
                          Fluttertoast.showToast(msg: snapshot.error.toString());
                        }
                        return Container();
                      }
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}

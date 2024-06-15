import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class MyAudioHandler extends BaseAudioHandler {

  final _player = AudioPlayer();

  Stream<IcyMetadata?> get icyMetadataStream => _player.icyMetadataStream;

  Stream<bool> get bufferingStream => _player.processingStateStream.map((state) => state == ProcessingState.buffering);

  Stream<bool> get playingStream => _player.playingStream;

  MyAudioHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  Future<Duration?> setAudioSource(AudioSource source) async {
    return _player.setAudioSource(source);
  }

  void setMediaItem(MediaItem mediaItem) {
    this.mediaItem.add(mediaItem);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      androidCompactActionIndices: const [
        0,
        //1,
       // 2
      ],
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}

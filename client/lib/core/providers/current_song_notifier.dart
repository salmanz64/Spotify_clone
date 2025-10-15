import 'package:client/core/utils.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  Song? build() {
    return null;
  }

  void updateSong({required Song song}) async {
    await audioPlayer?.stop();
    await audioPlayer?.dispose();

    audioPlayer = AudioPlayer();
    isPlaying = true;
    state = song;
    ref.read(homeLocalRepositoryProvider).uploadLocalSong(song);
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,

        album: song.artist,
        title: song.song_name,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    // to track back to 0 after listening
    audioPlayer!.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;

        state = state!.copyWith(hex_code: song.hex_code);
      }
    });

    await audioPlayer!.setAudioSource(audioSource);

    await audioPlayer!.play();
  }

  void playPause() {
    //in order to play and pause
    if (isPlaying) {
      audioPlayer?.stop();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    // no state = state because same may not change the ui
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}

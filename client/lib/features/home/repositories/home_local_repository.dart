import 'package:client/features/home/models/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final recentSongs = Hive.box('recentSongs');

  void uploadLocalSong(Song song) {
    recentSongs.put(song.id, song.toJson());
  }

  List<Song> loadLocalSongs() {
    List<Song> songs = [];
    for (final key in recentSongs.keys) {
      songs.add(Song.fromJson(recentSongs.get(key)));
    }

    return songs;
  }
}

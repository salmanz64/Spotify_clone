import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodal/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getAllFavSongsProvider)
        .when(
          data: (data) {
            final songs = data;
            return ListView.builder(
              itemCount: songs.length + 1,
              itemBuilder: (context, index) {
                if (songs.length == index) {
                  return GestureDetector(
                    onTap:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UploadSongPage(),
                          ),
                        ),
                    child: ListTile(
                      leading: Icon(Icons.add_circle_outline_sharp),
                      title: Text('Upload New Songs'),
                    ),
                  );
                }
                return GestureDetector(
                  onTap:
                      () => ref
                          .watch(currentSongNotifierProvider.notifier)
                          .updateSong(song: songs[index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(songs[index].thumbnail_url),
                    ),
                    title: Text(songs[index].song_name),
                    subtitle: Text(songs[index].artist),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        );
  }
}

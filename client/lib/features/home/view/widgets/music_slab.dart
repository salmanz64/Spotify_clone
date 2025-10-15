import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/view/pages/music_page.dart';
import 'package:client/features/home/viewmodal/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(currentSongNotifierProvider);
    final songProvider = ref.read(currentSongNotifierProvider.notifier);
    final favorites = ref.watch(
      currentUserNotifierProvider.select((value) => value!.favorites),
    );

    if (song == null) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap:
            /// animation screen
            () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MusicPage();
                },
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  final tween = Tween(
                    begin: Offset(1.0, 0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn));

                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 70,

              decoration: BoxDecoration(
                color: hexToColor(song.hex_code),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(song.thumbnail_url),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.song_name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(song.artist, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed:
                        () => ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: song.id),

                    icon: Icon(
                      favorites
                              .where((element) => song.id == element.song_id)
                              .toList()
                              .isEmpty
                          ? Icons.favorite_border_outlined
                          : Icons.favorite,
                    ),
                  ),
                  IconButton(
                    onPressed: () => songProvider.playPause(),
                    icon: Icon(
                      songProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream: songProvider.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final position = snapshot.data;
                final duration = songProvider.audioPlayer!.duration;

                var sliderValue = 0.0;

                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }

                return Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    height: 2,
                    width: sliderValue * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Pallete.inactiveSeekColor),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

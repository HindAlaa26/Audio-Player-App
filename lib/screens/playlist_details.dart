import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/screens/home_screen.dart';
import 'package:audio_player/shared_component/carousel_slider.dart';
import 'package:audio_player/shared_component/song.dart';
import 'package:flutter/material.dart';

class PlaylistDetails extends StatelessWidget {
  final Playlist playlist;
  const PlaylistDetails({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    // Extract images and titles from playlist audios
    List<String> carouselImages =
        playlist.audios.map((audio) => audio.metas.image?.path ?? '').toList();
    List<String> carouselTitles =
        playlist.audios.map((audio) => audio.metas.title ?? '').toList();
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade400,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "PlayList Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CarouselWithIndicator(
              carouselSliderImage: carouselImages,
              carouselSliderTitle: carouselTitles,
            ),
            Expanded(
              child: ListView(
                children: [
                  for (var song in playlist.audios)
                    Song(
                      audio: song,
                      heroSong: "${song.metas.title}",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

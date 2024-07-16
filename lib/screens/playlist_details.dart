import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/shared_component/song.dart';
import 'package:flutter/material.dart';

class PlaylistDetails extends StatelessWidget {
  final Playlist playlist;
  const PlaylistDetails({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade400,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
      body: ListView(
        children: [
          for (var song in playlist.audios)
            Song(
              audio: song,
              heroSong: "${song.metas.title}",
            ),
        ],
      ),
    );
  }
}

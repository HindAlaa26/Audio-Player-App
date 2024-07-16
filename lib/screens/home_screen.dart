import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/shared_component/sound_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final playlistEx = Playlist(audios: [
    Audio("assets/audios/playlist1/beautiful-song.mp3",
        metas: Metas(
          title: "Beautiful Song",
          image: const MetasImage(
              path: 'assets/images/beautiful.png', type: ImageType.asset),
        )),
    Audio("assets/audios/playlist1/just-relax.mp3",
        metas: Metas(
          title: "Just Relax",
          image: const MetasImage(
              path: 'assets/images/relax .jpg', type: ImageType.asset),
        )),
    Audio("assets/audios/playlist1/Piano song.mp3",
        metas: Metas(
          title: "Piano Song",
          image: const MetasImage(
              path: 'assets/images/piano.jpg', type: ImageType.asset),
        )),
    Audio("assets/audios/playlist1/river-tram.mp3",
        metas: Metas(
          title: "River Tram",
          image: const MetasImage(
              path: 'assets/images/river.jpg', type: ImageType.asset),
        )),
  ]);
  final playlistEx2 = Playlist(audios: [
    Audio("assets/audios/playlist2/coniferous-forest.mp3",
        metas: Metas(
          title: "Coniferous Forest ",
          image: const MetasImage(
              path: 'assets/images/Coniferous Forest.jpg',
              type: ImageType.asset),
        )),
    Audio("assets/audios/playlist2/my-life.mp3",
        metas: Metas(
          title: "My Life ",
          image: const MetasImage(
              path: 'assets/images/My Life.jpg', type: ImageType.asset),
        )),
    Audio("assets/audios/playlist2/ambient-classical-guitar.mp3",
        metas: Metas(
          title: "Ambient Classical Guitar",
          image: const MetasImage(
              path: 'assets/images/Ambient Classical Guitar.jpg',
              type: ImageType.asset),
        )),
    Audio("assets/audios/playlist2/guitar-mexican-happy.mp3",
        metas: Metas(
          title: "Guitar Mexican Happy ",
          image: const MetasImage(
              path: 'assets/images/Guitar Mexican Happy.jpg',
              type: ImageType.asset),
        )),
  ]);
  final List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
    playlists.addAll([playlistEx, playlistEx2]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade400,
        title: const Text(
          "Song App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView.separated(
              itemBuilder: (context, index) => SoundPlayer(
                    playlist: playlists[index],
                    heroTag: 'SoundPlayList-$index',
                  ),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
              itemCount: playlists.length),
        ),
      ),
    );
  }
}

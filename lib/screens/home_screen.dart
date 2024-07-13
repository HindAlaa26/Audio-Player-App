import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
        Playlist(audios: [
          Audio("assets/audios/beautiful-song.mp3",
              metas: Metas(
                title: "Beautiful Song",
                image: const MetasImage(
                    path: 'assets/images/beautiful.png', type: ImageType.asset),
              )),
          Audio("assets/audios/just-relax.mp3",
              metas: Metas(
                title: "Just Relax",
                image: const MetasImage(
                    path: 'assets/images/relax .jpg', type: ImageType.asset),
              )),
          Audio("assets/audios/Piano song.mp3",
              metas: Metas(
                title: "Piano Song",
                image: const MetasImage(
                    path: 'assets/images/piano.jpg', type: ImageType.asset),
              )),
          Audio("assets/audios/river-tram.mp3",
              metas: Metas(
                title: "River Tram",
                image: const MetasImage(
                    path: 'assets/images/river.jpg', type: ImageType.asset),
              )),
        ]),
        autoStart: false,
        loopMode: LoopMode.playlist,
        showNotification: true,
        volume: 1.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: StreamBuilder(
          stream: assetsAudioPlayer.realtimePlayingInfos,
          builder: (context, snapshot) {
            final playingInfo = snapshot.data;
            final currentAudio = playingInfo?.current;
            final audioImage = currentAudio?.audio.audio.metas.image?.path;
            final audioTitle = currentAudio?.audio.audio.metas.title ?? '';
            return Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blueGrey,
                  image: DecorationImage(
                      image: AssetImage(
                          audioImage ?? 'assets/images/beautiful.png'),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // song name
                  Text(
                    audioTitle.isEmpty ? "Please Play Your Song" : audioTitle,
                    style: const TextStyle(
                        fontSize: 30,
                        shadows: [
                          Shadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              offset: Offset(0, 3))
                        ],
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  // song player
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: (currentAudio?.index ?? 0) == 0
                              ? null
                              : () {
                                  assetsAudioPlayer.previous();
                                },
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 50,
                            color: Colors.white,
                          )),
                      getPlayerButtonWidget,
                      IconButton(
                          onPressed: (currentAudio?.index ?? 0) ==
                                  (assetsAudioPlayer.playlist?.audios.length ??
                                          0) -
                                      1
                              ? null
                              : () {
                                  assetsAudioPlayer.next();
                                },
                          icon: const Icon(
                            Icons.skip_next,
                            size: 50,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //song slider
                  Slider(
                      value:
                          playingInfo?.currentPosition.inSeconds.toDouble() ??
                              0.0,
                      min: 0,
                      max: snapshot.data?.duration.inSeconds.toDouble() ?? 0.0,
                      onChanged: (value) {
                        assetsAudioPlayer
                            .seek(Duration(seconds: value.toInt()));
                      }),
                  // song time
                  Text(
                    "${convertSeconds(playingInfo?.currentPosition.inSeconds ?? 0)} / ${convertSeconds(playingInfo?.duration.inSeconds ?? 0)}",
                    style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(0, 3))
                        ],
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get getPlayerButtonWidget =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.large(
          elevation: 15,
          onPressed: () {
            if (isPlaying) {
              assetsAudioPlayer.pause();
            } else {
              assetsAudioPlayer.play();
            }
            setState(() {});
          },
          shape: const CircleBorder(),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
      });

  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String second = (seconds % 60).toString();
    return "${minutes.padLeft(2, "0")} : ${second.padLeft(2, "0")}";
  }
}

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import '../shared_component/volume_speed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  double volumeEx = 1.0;
  double playSpeedEx = 1.0;
  List<IconData> volumeIcons = [
    Icons.volume_up,
    Icons.volume_down,
    Icons.volume_mute
  ];
  List<double> volumeValues = [1.0, 0.5, 0];
  List<double> speedValues = [1.0, 4.0, 8.0, 16.0];
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
    );

    assetsAudioPlayer.playSpeed.listen((event) {
      print('>>>>>${event}');
    });

    assetsAudioPlayer.volume.listen((event) {
      volumeEx = event;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final playingInfo = snapshot.data;
              final currentAudio = playingInfo?.current;
              final audioImage = currentAudio?.audio.audio.metas.image?.path;
              final audioTitle = currentAudio?.audio.audio.metas.title ?? '';
              return Container(
                height: 510,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blueGrey,
                    image: DecorationImage(
                        image: AssetImage(
                            audioImage ?? 'assets/images/beautiful.png'),
                        fit: BoxFit.fill)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // song name
                    Text(
                      audioTitle.isEmpty ? "Please Play Your Song" : audioTitle,
                      style: const TextStyle(
                          fontSize: 30,
                          shadows: [
                            Shadow(
                                color: Colors.black,
                                blurRadius: 3,
                                offset: Offset(0, 3))
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // song player
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: currentAudio?.index == 0
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
                                    (assetsAudioPlayer
                                                .playlist?.audios.length ??
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
                    //song sounds
                    VolumeSpeed(
                      dataEx: volumeEx,
                      type: "Volume",
                      data: [
                        for (int i = 0; i < 3; i++)
                          ButtonSegment(
                            icon: Icon(
                              volumeIcons[i],
                              size: 20,
                            ),
                            value: volumeValues[i],
                          ),
                      ],
                      setData: setVolume,
                    ),
                    // song speed
                    VolumeSpeed(
                      dataEx: playSpeedEx,
                      type: "Speed",
                      data: [
                        for (int i = 0; i < 4; i++)
                          ButtonSegment(
                            icon: Text('${i + 1}X'),
                            value: speedValues[i],
                          ),
                      ],
                      setData: setSpeed,
                    ),
                    //song slider
                    Slider(
                        value:
                            playingInfo?.currentPosition.inSeconds.toDouble() ??
                                0.0,
                        min: 0,
                        max:
                            snapshot.data?.duration.inSeconds.toDouble() ?? 0.0,
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
                                color: Colors.black,
                                blurRadius: 2,
                                offset: Offset(0, 2))
                          ],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void setSpeed(values) {
    playSpeedEx = values.first.toDouble();
    assetsAudioPlayer.setPlaySpeed(playSpeedEx);
    setState(() {});
  }

  void setVolume(Set<num> values) {
    volumeEx = values.first.toDouble();
    assetsAudioPlayer.setVolume(volumeEx);
    setState(() {});
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

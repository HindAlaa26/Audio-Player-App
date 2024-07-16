import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class Song extends StatefulWidget {
  final Audio audio;
  final String heroSong;
  const Song({super.key, required this.audio, required this.heroSong});

  @override
  State<Song> createState() => _SongState();
}

class _SongState extends State<Song> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  void initState() {
    assetsAudioPlayer.open(widget.audio, autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade300,
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 2)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // song image
          CircleAvatar(
            radius: 40,
            foregroundImage: AssetImage(widget.audio.metas.image?.path ??
                'assets/images/beautiful.png'),
          ),
          const SizedBox(
            width: 10,
          ),
          // song name & slider
          Expanded(
            child: Column(
              children: [
                // song name
                Text(
                  widget.audio.metas.title ?? "No Title",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                //song slider
                StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    return Slider(
                        activeColor: Colors.blueGrey,
                        value: snapshot.data?.currentPosition.inSeconds
                                .toDouble() ??
                            0.0,
                        min: 0,
                        max:
                            snapshot.data?.duration.inSeconds.toDouble() ?? 0.0,
                        onChanged: (value) {
                          seekPlayer(value);
                        });
                  },
                )
              ],
            ),
          ),
          // song time
          StreamBuilder(
            stream: assetsAudioPlayer.realtimePlayingInfos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Text(
                    convertSeconds(snapshot.data?.duration.inSeconds ?? 0),
                    style: const TextStyle(fontSize: 20),
                  ),
                  getPlayerButtonWidget
                ],
              );
            },
          )
        ],
      ),
    );
  }

  void seekPlayer(double value) {
    assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
  }

  Widget get getPlayerButtonWidget =>
      assetsAudioPlayer.builderIsPlaying(builder: (ctx, isPlaying) {
        return FloatingActionButton.small(
          heroTag: widget.heroSong,
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
            size: 20,
          ),
        );
      });
  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String second = (seconds % 60).toString();
    return "${minutes.padLeft(2, "0")} : ${second.padLeft(2, "0")}";
  }
}

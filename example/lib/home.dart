import 'package:flutter/material.dart';
import 'package:youtube_video_player/potrait_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player Example"),
      ),
      body: const PotraitPlayer(
          link: "https://www.youtube.com/watch?v=zjfQo5E1fPM",
          aspectRatio: 4 / 3,
          kColorBlack: Colors.black,
          kColorPrimary: Colors.amber,
          kColorWhite: Colors.white),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_video_player/potrait_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? link = "https://youtu.be/7bRloz4KmR4?si=Cu7zM7DUoqOf5Umv";
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player Example"),
      ),
      body: Column(
        children: [
          link != null
              ? PotraitPlayer(
                  autoPlay: false,
                  link: link!,
                  aspectRatio: 16 / 9,
                  controlsColor: Colors.greenAccent,
                  primaryColor: Colors.red,
                  textColor: Colors.grey)
              : Container(),
          TextField(
            controller: controller,
            decoration: InputDecoration(
                suffix: IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        link = controller.text;
                      });
                    },
                    icon: const Icon(Icons.add))),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../const/colors/colors.dart';
import 'landscape_controller.dart';
import 'video_player_controller.dart';
import 'landscape_video.dart';

// ignore: must_be_immutable
class LandscapePlayer extends StatelessWidget {
  final Color? kColorWhite;
  final Color? kColorPrimary;
  final Color? kColorBlack;
  LandscapePlayer(
      {Key? key, this.kColorWhite, this.kColorPrimary, this.kColorBlack})
      : super(key: key);
  LandscapeController controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Get.find<VideoPlayerSreenController>().isInitialized.value
            ? LandscapeVideo()
            : Container(
                color: kColorBlack,
                child: Center(
                    child: CircularProgressIndicator(
                  color: kColorPrimary,
                ))),
      ),
    );
  }
}

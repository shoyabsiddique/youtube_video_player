import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../const/colors/colors.dart';
import 'landscape_controller.dart';
import 'video_player_controller.dart';
import 'landscape_video.dart';

// ignore: must_be_immutable
class LandscapePlayer extends StatelessWidget {
  final Color? controlsColor;
  final Color? primaryColor;
  final Color? textColor;
  LandscapePlayer({
    super.key,
    this.controlsColor,
    this.primaryColor,
    this.textColor,
  });
  LandscapeController controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Get.find<VideoPlayerSreenController>().isInitialized.value
            ? LandscapeVideo(
                controlsColor: controlsColor,
                primaryColor: primaryColor,
                textColor: textColor,
              )
            : Container(
                color: Colors.black,
                child: Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ))),
      ),
    );
  }
}

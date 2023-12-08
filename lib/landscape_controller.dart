import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:subtitle/subtitle.dart';
import 'package:video_player/video_player.dart';

class LandscapeController extends GetxController with WidgetsBindingObserver {
  late VideoPlayerController controller;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  RxBool isPlaying = false.obs;
  var sliderVal = 0.0.obs;
  var isVisible = false.obs;
  var volVisible = false.obs;
  var brightVisible = false.obs;
  var playback = 4.obs;
  var caption = [].obs;
  var subVal = 0.obs;
  var lock = false.obs;
  Subtitle? currentSubtitle;
  var appLifeCycleState = AppLifecycleState;
  // Rx<Widget> toPresent = LandscapeVideo().obs;
  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // toPresent.value = Container();
    }
    if (state == AppLifecycleState.resumed) {
      // toPresent.value = LandscapeVideo();
    }
    super.didChangeAppLifecycleState(state);
  }
}

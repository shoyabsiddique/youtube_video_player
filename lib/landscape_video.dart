import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

import 'landscape_controller.dart';
import 'video_player_controller.dart';

class LandscapeVideo extends StatelessWidget {
  LandscapeVideo(
      {Key? key, this.kColorWhite, this.kColorPrimary, this.kColorBlack})
      : super(key: key);
  final Color? kColorWhite;
  final Color? kColorPrimary;
  final Color? kColorBlack;
  final VideoPlayerSreenController controller =
      Get.find<VideoPlayerSreenController>();
  final LandscapeController _controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return true;
      },
      child: Obx(
        () => GestureDetector(
          onTap: () {
            if (!_controller.lock.value) {
              _controller.isVisible.value = !_controller.isVisible.value;
              Future.delayed(const Duration(seconds: 10), () {
                _controller.isVisible.value = false;
              });
            }
          },
          child: controller.isInitialized.value
              ? Stack(
                  // fit: StackFit.expand,
                  // clipBehavior: Clip.antiAlias,
                  children: [
                    VideoPlayer(controller.controller), //Video Player
                    Obx(
                      () => controller.caption.isNotEmpty
                          ? ClosedCaption(
                              text: controller.currentSubtitle?.data,
                              textStyle: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ), //Captions
                    Visibility(
                      visible: _controller.isVisible.value,
                      // visible: true,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black45),
                        width: double.infinity,
                        height: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 2,
                              top: 2,
                              child: TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.arrow_back)),
                            ),
                            Positioned(
                                left: 30,
                                top: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.video!.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width >= 600 ? 10 : 8),
                                    ),
                                    Text(
                                      controller.video!.author,
                                      style: const TextStyle(
                                          color: Colors.white54),
                                    )
                                  ],
                                )),
                            Center(
                              child: SizedBox(
                                width: 250,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      child: const Icon(Icons.replay_10),
                                      onPressed: () {
                                        controller.controller.seekTo(controller
                                                .controller.value.position -
                                            const Duration(seconds: 10));
                                      },
                                    ),
                                    TextButton(
                                      child: controller.isPlaying.value
                                          ? const Icon(Icons.pause)
                                          : const Icon(Icons.play_arrow),
                                      onPressed: () {
                                        controller.isPlaying.value =
                                            !controller.isPlaying.value;
                                        controller.controller.value.isPlaying
                                            ? controller.controller.pause()
                                            : controller.controller.play();
                                      },
                                    ),
                                    TextButton(
                                      child: const Icon(Icons.forward_10),
                                      onPressed: () {
                                        controller.controller.seekTo(controller
                                                .controller.value.position +
                                            const Duration(seconds: 10));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ), //Controls
                            Positioned(
                              bottom: 180,
                              left: 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: controller.brightVisible.value,
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: SizedBox(
                                        width: 80,
                                        // margin: EdgeInsets.only(
                                        //     top: 30,
                                        //     bottom: 30,
                                        //     left: 20,
                                        //     right: 18),
                                        child: SliderTheme(
                                          data: const SliderThemeData(
                                              trackHeight: 2,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 6),
                                              overlayShape:
                                                  RoundSliderOverlayShape(
                                                      overlayRadius: 1),
                                              thumbColor: Colors.white,
                                              activeTrackColor: Colors.white,
                                              inactiveTrackColor: Colors.grey),
                                          child: Slider(
                                            value:
                                                controller.setBrightness.value,
                                            min: 0.0,
                                            max: 1.0,
                                            // divisions: duration.value.inSeconds.round(),
                                            onChanged: (double newValue) {
                                              // position.value =
                                              // Duration(seconds: newValue.toInt());
                                              controller.setBrightness.value =
                                                  newValue;
                                              ScreenBrightness()
                                                  .setScreenBrightness(
                                                      newValue);
                                            },
                                            mouseCursor:
                                                MouseCursor.uncontrolled,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                      onTap: () {
                                        controller.brightVisible.value =
                                            !controller.brightVisible.value;
                                        Future.delayed(
                                            const Duration(seconds: 5),
                                            () => controller
                                                .brightVisible.value = false);
                                      },
                                      child: const Icon(
                                          Icons.brightness_5_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 180,
                              right: 30,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: controller.volVisible.value,
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: SizedBox(
                                        width: 80,
                                        // margin: EdgeInsets.only(
                                        //     top: 30,
                                        //     bottom: 30,
                                        //     left: 20,
                                        //     right: 18),
                                        child: SliderTheme(
                                          data: const SliderThemeData(
                                              trackHeight: 2,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 6),
                                              overlayShape:
                                                  RoundSliderOverlayShape(
                                                      overlayRadius: 1),
                                              thumbColor: Colors.white,
                                              activeTrackColor: Colors.white,
                                              inactiveTrackColor: Colors.grey),
                                          child: Slider(
                                            value:
                                                controller.setVolumeValue.value,
                                            min: 0.0,
                                            max: 1.0,
                                            // divisions: duration.value.inSeconds.round(),
                                            onChanged: (double newValue) {
                                              // position.value =
                                              // Duration(seconds: newValue.toInt());
                                              controller.setVolumeValue.value =
                                                  newValue;
                                              controller.setVolumeValue.value ==
                                                      0
                                                  ? controller.isMute.value =
                                                      true
                                                  : controller.isMute.value =
                                                      false;
                                              controller.setVolumeValue.value =
                                                  newValue;
                                              controller.controller
                                                  .setVolume(newValue);
                                            },
                                            mouseCursor:
                                                MouseCursor.uncontrolled,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: InkWell(
                                      onTap: () {
                                        controller.volVisible.value =
                                            !controller.volVisible.value;
                                        Future.delayed(
                                            const Duration(seconds: 5),
                                            () => controller.volVisible.value =
                                                false);
                                      },
                                      child: Obx(() => !controller.isMute.value
                                          ? const Icon(Icons.volume_up_rounded)
                                          : const Icon(
                                              Icons.volume_off_rounded)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              alignment: Alignment.bottomCenter,
                              // height: 100,
                              width: double.infinity,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 45, bottom: 30, left: 20, right: 18),
                                // child: SliderTheme(
                                //   data: SliderThemeData(
                                //     trackHeight: 1,
                                //     thumbShape: RoundSliderThumbShape(
                                //         enabledThumbRadius: 3),
                                //     overlayShape: RoundSliderOverlayShape(
                                //         overlayRadius: 4),
                                //     thumbColor: kColorPrimary,
                                //     activeTrackColor: kColorPrimary,
                                //     inactiveTrackColor: Colors.grey,
                                //     showValueIndicator:
                                //         ShowValueIndicator.always,
                                //   ),
                                //   child: Slider(
                                //     label: controller.formatDuration(
                                //         controller.position.value),
                                //     value: controller.position.value.inSeconds
                                //         .toDouble(),
                                //     min: 0.0,
                                //     max: controller.duration.value.inSeconds
                                //         .toDouble(),
                                //     // divisions: duration.value.inSeconds.round(),
                                //     onChanged: (double newValue) {
                                //       // position.value =
                                //       // Duration(seconds: newValue.toInt());
                                //       controller.controller.seekTo(
                                //           Duration(seconds: newValue.toInt()));
                                //     },
                                //     mouseCursor: MouseCursor.defer,
                                //   ),
                                // ),
                                child: Obx(
                                  () => ProgressBar(
                                    // key: controller.mywidgetkey.value,
                                    barHeight: 2,
                                    baseBarColor: Colors.white,
                                    bufferedBarColor: Colors.grey[300],
                                    progressBarColor: kColorPrimary,
                                    thumbColor: kColorPrimary,
                                    thumbRadius: 5,
                                    progress: controller.position.value,
                                    total: controller.controller.value.duration,
                                    // buffered: controller
                                    //     .durationRangeToDuration(controller
                                    //         .controller.value.buffered),
                                    onSeek: (value) =>
                                        controller.controller.seekTo(value),
                                    timeLabelTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: kColorWhite,
                                        fontSize: 6),
                                    barCapShape: BarCapShape.round,
                                    timeLabelPadding: 5,
                                    timeLabelType: TimeLabelType.remainingTime,
                                  ),
                                ),
                              ), //Progress Bar
                            ),
                            // Container(
                            //     padding: EdgeInsets.only(
                            //         top: 420, left: 25, right: 25),
                            //     //Duration
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignmentaceBetween,
                            //       children: [
                            //         RichText(
                            //           text: TextSpan(
                            //             text: controller.formatDuration(
                            //                 controller.position.value),
                            //             style: const TextStyle(
                            //               fontSize: 10.0,
                            //               color: Colors.white,
                            //               decoration: TextDecoration.none,
                            //             ),
                            //           ),
                            //         ),
                            //         Text(
                            //           controller.formatDuration(
                            //               controller.duration.value),
                            //           style: const TextStyle(
                            //             fontSize: 10.0,
                            //             color: Colors.white,
                            //             decoration: TextDecoration.none,
                            //           ),
                            //         ),
                            //       ],
                            //     )),
                            //Bottom Bar Settings and Full Screen
                            Positioned(
                                top: 2,
                                right: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _controller.lock.value =
                                            !_controller.lock.value;
                                        _controller.isVisible.value = false;
                                      },
                                      style: TextButton.styleFrom(
                                        fixedSize: const Size(30, 30),
                                        minimumSize: const Size(30, 30),
                                        maximumSize: const Size(30, 30),
                                      ),
                                      child: const Icon(Icons.lock),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      style: TextButton.styleFrom(
                                        fixedSize: const Size(35, 35),
                                        minimumSize: const Size(35, 35),
                                        maximumSize: const Size(35, 35),
                                      ),
                                      child: const Icon(Icons.fullscreen_exit),
                                    ),
                                  ],
                                )),
                            Align(
                                // bottom: 16,
                                // right: 48,
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Get.defaultDialog(content: Popup());
                                          getBottomSheet(0, context);
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(Icons.high_quality_rounded),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Quality",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () => getBottomSheet(1, context),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.speed_rounded),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Playback Speed",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      const Row(
                                        children: [
                                          Icon(Icons.play_arrow_rounded),
                                          SizedBox(
                                            width: 4,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _controller.lock.value,
                      child: Positioned(
                        top: 2,
                        right: 35,
                        child: TextButton(
                          onPressed: () {
                            _controller.lock.value = !_controller.lock.value;
                            controller.isVisible.value = false;
                          },
                          style: TextButton.styleFrom(
                            fixedSize: const Size(35, 35),
                            minimumSize: const Size(35, 35),
                            maximumSize: const Size(35, 35),
                          ),
                          child: const Icon(Icons.minimize_rounded),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: kColorPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  void getBottomSheet(int num, BuildContext context) {
    controller.tabController.index = num;
    showModalBottomSheet(
      // backgroundColor: Colors.black,
      // title: "Settings",
      // titleStyle: TextStyle(
      //     color: Colors.white,
      //     fontWeight: FontWeight400),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      context: context,
      builder: (context) => Container(
          // height: 180,
          color: Colors.transparent,
          margin: Platform.isIOS
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 200, right: 200),
          height: 310,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: kColorWhite),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      " Settings",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          // color: Colors.white,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                TabBar(
                  labelColor: kColorPrimary,
                  unselectedLabelColor: Colors.white,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 8),
                  indicatorColor: Colors.white,
                  indicator: const BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          image: AssetImage("assets/icons/indicator.png"))),
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      text: "Quality".tr,
                    ),
                    Tab(
                      text: "Playback Speed".tr,
                    ),
                    // Tab(
                    //   text: "Subtitle",
                    // ),
                  ],
                  controller: controller.tabController,
                ),
                SizedBox(
                    height: 150,
                    child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          SingleChildScrollView(
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // children: [
                                //   RadioListTile(
                                //       // onPressed: () {},
                                //       controlAffinity:
                                //           ListTileControlAffinity.leading,
                                //       groupValue:
                                //           controller.qualityGroupValue.value,
                                //       onChanged: (val) {
                                //         controller.qualityGroupValue.value =
                                //             val!;
                                //       },
                                //       activeColor: kColorPrimary,
                                //       value: "Full HD upto 1080p",
                                //       title: Text.rich(
                                //         TextSpan(text: "Full HD ", children: [
                                //           TextSpan(
                                //               text: "upto 1080p",
                                //               style: kTextStylePoppinsMedium
                                //                   .copyWith(
                                //                 fontWeight: FontWeight300,
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "Full HD upto 1080p"
                                //                     ? kColorPrimary
                                //                         ithOpacity(0.5)
                                //                     : Colors.black
                                //                         ithOpacity(0.5),
                                //               ))
                                //         ]),
                                //         style:
                                //             kTextStylePoppinsRegular.copyWith(
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "Full HD upto 1080p"
                                //                     ? kColorPrimary
                                //                     : Colors.black,
                                //                 fontWeight: FontWeight600),
                                //       )),
                                //   RadioListTile(
                                //       // onPressed: () {},
                                //       controlAffinity:
                                //           ListTileControlAffinity.leading,
                                //       groupValue:
                                //           controller.qualityGroupValue.value,
                                //       onChanged: (val) {
                                //         controller.qualityGroupValue.value =
                                //             val!;
                                //       },
                                //       activeColor: kColorPrimary,
                                //       value: "HD upto 1080p",
                                //       title: Text.rich(
                                //         TextSpan(text: "HD ", children: [
                                //           TextSpan(
                                //               text: "upto 720p",
                                //               style: kTextStylePoppinsMedium
                                //                   .copyWith(
                                //                 fontWeight: FontWeight300,
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "HD upto 720p"
                                //                     ? kColorPrimary
                                //                         ithOpacity(0.5)
                                //                     : Colors.black
                                //                         ithOpacity(0.5),
                                //               ))
                                //         ]),
                                //         style:
                                //             kTextStylePoppinsRegular.copyWith(
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "HD upto 720p"
                                //                     ? kColorPrimary
                                //                     : Colors.black,
                                //                 fontWeight: FontWeight600),
                                //       )),
                                //   RadioListTile(
                                //       // onPressed: () {},
                                //       controlAffinity:
                                //           ListTileControlAffinity.leading,
                                //       groupValue:
                                //           controller.qualityGroupValue.value,
                                //       onChanged: (val) {
                                //         controller.qualityGroupValue.value =
                                //             val!;
                                //       },
                                //       activeColor: kColorPrimary,
                                //       value: "SD upto 480p",
                                //       title: Text.rich(
                                //         TextSpan(text: "SD ", children: [
                                //           TextSpan(
                                //               text: "upto 480p",
                                //               style: kTextStylePoppinsMedium
                                //                   .copyWith(
                                //                 fontWeight: FontWeight300,
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "SD upto 480p"
                                //                     ? kColorPrimary
                                //                         ithOpacity(0.5)
                                //                     : Colors.black
                                //                         ithOpacity(0.5),
                                //               ))
                                //         ]),
                                //         style:
                                //             kTextStylePoppinsRegular.copyWith(
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "SD upto 480p"
                                //                     ? kColorPrimary
                                //                     : Colors.black,
                                //                 fontWeight: FontWeight600),
                                //       )),
                                //   RadioListTile(
                                //       // onPressed: () {},
                                //       controlAffinity:
                                //           ListTileControlAffinity.leading,
                                //       groupValue:
                                //           controller.qualityGroupValue.value,
                                //       onChanged: (val) {
                                //         controller.qualityGroupValue.value =
                                //             val!;
                                //       },
                                //       activeColor: kColorPrimary,
                                //       value: "Low Data Saver",
                                //       title: Text.rich(
                                //         TextSpan(text: "Low ", children: [
                                //           TextSpan(
                                //               text: "Data Saver",
                                //               style: kTextStylePoppinsMedium
                                //                   .copyWith(
                                //                 fontWeight: FontWeight300,
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "Low Data Saver"
                                //                     ? kColorPrimary
                                //                         ithOpacity(0.5)
                                //                     : Colors.black
                                //                         ithOpacity(0.5),
                                //               ))
                                //         ]),
                                //         style:
                                //             kTextStylePoppinsRegular.copyWith(
                                //                 color: controller
                                //                             .qualityGroupValue
                                //                             .value ==
                                //                         "Low Data Saver"
                                //                     ? kColorPrimary
                                //                     : Colors.black,
                                //                 fontWeight: FontWeight600),
                                //       )),
                                //   SizedBox(
                                //     height: 20,
                                //   )
                                // ],
                                children: controller.qualities.map((element) {
                                  var quality = element.qualityLabel == "144p"
                                      ? "Low "
                                      : element.qualityLabel == "240p"
                                          ? "Low "
                                          : element.qualityLabel == "360p"
                                              ? "SD "
                                              : element.qualityLabel == "480p"
                                                  ? "SD "
                                                  : element.qualityLabel ==
                                                          "720p"
                                                      ? "HD "
                                                      : "Full HD ";
                                  quality += "upto ${element.qualityLabel}";
                                  return RadioListTile(
                                      // onPressed: () {},
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      groupValue:
                                          controller.qualityGroupValue.value,
                                      onChanged: (val) {
                                        controller.controller.pause();
                                        controller.qualityGroupValue.value =
                                            val!;
                                        Duration position = controller
                                            .controller.value.position;
                                        controller.isPlaying.value = false;
                                        controller.isInitialized.value = false;
                                        controller.controller =
                                            VideoPlayerController.contentUri(
                                                element.url,
                                                videoPlayerOptions:
                                                    VideoPlayerOptions())
                                              ..initialize().then((value) {
                                                controller.controller
                                                    .seekTo(position);
                                                controller.isInitialized.value =
                                                    true;
                                                controller.controller.play();
                                                controller.isPlaying.value =
                                                    true;
                                              });
                                        controller.controller.addListener(() {
                                          controller.position.value = controller
                                              .controller.value.position;
                                          controller.sliderVal.value =
                                              controller.position.value
                                                      .inSeconds /
                                                  controller
                                                      .duration.value.inSeconds;
                                        });
                                      },
                                      visualDensity: const VisualDensity(
                                          vertical:
                                              VisualDensity.minimumDensity,
                                          horizontal:
                                              VisualDensity.minimumDensity),
                                      activeColor: kColorPrimary,
                                      value: quality,
                                      title: Text.rich(
                                        TextSpan(
                                            text: element.qualityLabel == "144p"
                                                ? "Low "
                                                : element.qualityLabel == "240p"
                                                    ? "Low "
                                                    : element.qualityLabel ==
                                                            "360p"
                                                        ? "SD "
                                                        : element.qualityLabel ==
                                                                "480p"
                                                            ? "SD "
                                                            : element.qualityLabel ==
                                                                    "720p"
                                                                ? "HD "
                                                                : "Full HD ",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 8,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "upto ${element.qualityLabel}",
                                                  style: const TextStyle()
                                                      .copyWith(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 9,
                                                    color: controller
                                                                .qualityGroupValue
                                                                .value ==
                                                            quality
                                                        ? kColorPrimary!
                                                            .withOpacity(0.5)
                                                        : Colors.black
                                                            .withOpacity(0.5),
                                                  ))
                                            ]),
                                        style: const TextStyle().copyWith(
                                            color: controller.qualityGroupValue
                                                        .value ==
                                                    quality
                                                ? kColorPrimary
                                                : Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                      ));
                                }).toList(),
                              ),
                            ),
                          ),
                          Obx(
                            () => SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 4;
                                      controller.controller.setPlaybackSpeed(1);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 4,
                                    activeColor: kColorPrimary,
                                    title: Text("Normal",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 4
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.controller
                                          .setPlaybackSpeed(0.25);
                                      controller.playback.value = val!;
                                    },
                                    value: 1,
                                    groupValue: controller.playback.value,
                                    title: Text("0.25x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 1
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = val!;
                                      controller.controller
                                          .setPlaybackSpeed(0.5);
                                    },
                                    activeColor: kColorPrimary,
                                    value: 2,
                                    groupValue: controller.playback.value,
                                    title: Text("0.5x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 2
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 3;
                                      controller.controller
                                          .setPlaybackSpeed(0.75);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 3,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: kColorPrimary,
                                    title: Text("0.75x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 3
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.controller
                                          .setPlaybackSpeed(1.25);
                                      controller.playback.value = 5;
                                    },
                                    groupValue: controller.playback.value,
                                    value: 5,
                                    activeColor: kColorPrimary,
                                    title: Text("1.25x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 5
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 6;
                                      controller.controller
                                          .setPlaybackSpeed(1.5);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 6,
                                    activeColor: kColorPrimary,
                                    title: Text("1.5x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 6
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 7;
                                      controller.controller
                                          .setPlaybackSpeed(1.75);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 7,
                                    activeColor: kColorPrimary,
                                    title: Text("1.75x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 7
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 8;
                                      controller.controller.setPlaybackSpeed(2);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 8,
                                    activeColor: kColorPrimary,
                                    title: Text("2x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 8
                                                    ? kColorPrimary
                                                    : Colors.black)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          )),
      isScrollControlled: true,
    );
  }
}

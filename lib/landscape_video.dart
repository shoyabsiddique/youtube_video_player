import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

import 'landscape_controller.dart';
import 'video_player_controller.dart';

class LandscapeVideo extends StatelessWidget {
  LandscapeVideo({
    Key? key,
    this.controlsColor,
    this.primaryColor,
    this.textColor,
  }) : super(key: key);
  final Color? controlsColor;
  final Color? primaryColor;
  final Color? textColor;
  final VideoPlayerSreenController controller =
      Get.find<VideoPlayerSreenController>();
  final LandscapeController _controller = Get.put(LandscapeController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: true,
      onPopInvoked: (val) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Get.delete<LandscapeController>();
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
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: textColor ?? Colors.white,
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
                                  Navigator.pop(context);
                                  Get.delete<LandscapeController>();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/back_icon.svg",
                                  package: "youtube_video_player",
                                  color: textColor,
                                ),
                              ),
                            ),
                            Positioned(
                                left: 60,
                                top: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Text(
                                        controller.video!.title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: width >= 600 ? 15 : 12),
                                      ),
                                    ),
                                    Text(
                                      controller.video!.author,
                                      style: TextStyle(
                                          color: textColor ?? Colors.white54),
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
                                      child: SvgPicture.asset(
                                        "assets/icons/10rev.svg",
                                        width: 30,
                                        height: 30,
                                        color: controlsColor,
                                        package: "youtube_video_player",
                                      ),
                                      onPressed: () {
                                        controller.controller.seekTo(controller
                                                .controller.value.position -
                                            const Duration(seconds: 10));
                                      },
                                    ),
                                    TextButton(
                                      child: SvgPicture.asset(
                                        controller.isPlaying.value
                                            ? "assets/icons/pause_video.svg"
                                            : "assets/icons/play_video.svg",
                                        width: 48,
                                        color: controlsColor,
                                        package: "youtube_video_player",
                                      ),
                                      onPressed: () {
                                        controller.isPlaying.value =
                                            !controller.isPlaying.value;
                                        controller.controller.value.isPlaying
                                            ? controller.controller.pause()
                                            : controller.controller.play();
                                      },
                                    ),
                                    TextButton(
                                      child: SvgPicture.asset(
                                          "assets/icons/10for.svg",
                                          width: 30,
                                          height: 30,
                                          color: controlsColor,
                                          package: "youtube_video_player"),
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
                              bottom: 100,
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
                                          data: SliderThemeData(
                                              trackHeight: 2,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                      enabledThumbRadius: 6),
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                      overlayRadius: 1),
                                              thumbColor:
                                                  primaryColor ?? Colors.white,
                                              activeTrackColor:
                                                  primaryColor ?? Colors.white,
                                              inactiveTrackColor:
                                                  controlsColor ?? Colors.grey),
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
                                    width: 55,
                                    height: 55,
                                    child: TextButton(
                                        onPressed: () {
                                          controller.brightVisible.value =
                                              !controller.brightVisible.value;
                                          Future.delayed(
                                              const Duration(seconds: 5),
                                              () => controller
                                                  .brightVisible.value = false);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/brightness.svg",
                                          package: "youtube_video_player",
                                          color: controlsColor,
                                          height: 20,
                                          width: 20,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 100,
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
                                          data: SliderThemeData(
                                              trackHeight: 2,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 6),
                                              overlayShape:
                                                  RoundSliderOverlayShape(
                                                      overlayRadius: 1),
                                              thumbColor:
                                                  primaryColor ?? Colors.white,
                                              activeTrackColor:
                                                  primaryColor ?? Colors.white,
                                              inactiveTrackColor:
                                                  controlsColor ?? Colors.grey),
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
                                    width: 55,
                                    height: 55,
                                    child: TextButton(
                                      onPressed: () {
                                        controller.volVisible.value =
                                            !controller.volVisible.value;
                                        Future.delayed(
                                            const Duration(seconds: 5),
                                            () => controller.volVisible.value =
                                                false);
                                      },
                                      child: Obx(() => !controller.isMute.value
                                          ? SvgPicture.asset(
                                              "assets/icons/volume.svg",
                                              package: "youtube_video_player",
                                              color: controlsColor,
                                              width: 20,
                                              height: 20,
                                            )
                                          : SvgPicture.asset(
                                              "assets/icons/mute.svg",
                                              package: "youtube_video_player",
                                              color: controlsColor,
                                              width: 20,
                                              height: 20,
                                            )),
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
                                //     thumbColor: primaryColor,
                                //     activeTrackColor: primaryColor,
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
                                    progressBarColor: primaryColor,
                                    thumbColor: primaryColor,
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
                                        color: textColor,
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
                                        child: SvgPicture.asset(
                                          "assets/icons/lock.svg",
                                          width: 30,
                                          height: 30,
                                          color: controlsColor,
                                          package: "youtube_video_player",
                                        )),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        fixedSize: const Size(35, 35),
                                        minimumSize: const Size(35, 35),
                                        maximumSize: const Size(35, 35),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/icons/minimize.svg",
                                        width: 50,
                                        height: 50,
                                        color: controlsColor,
                                        package: "youtube_video_player",
                                      ),
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
                          child: SvgPicture.asset(
                            "assets/icons/lock-open.svg",
                            width: 30,
                            height: 30,
                            package: "youtube_video_player",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
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
                color: textColor),
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
                          Navigator.pop(context);
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
                  labelColor: primaryColor,
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
                                //       activeColor: primaryColor,
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
                                //                     ? primaryColor
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
                                //                     ? primaryColor
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
                                //       activeColor: primaryColor,
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
                                //                     ? primaryColor
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
                                //                     ? primaryColor
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
                                //       activeColor: primaryColor,
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
                                //                     ? primaryColor
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
                                //                     ? primaryColor
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
                                //       activeColor: primaryColor,
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
                                //                     ? primaryColor
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
                                //                     ? primaryColor
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
                                      activeColor: primaryColor,
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
                                                        ? primaryColor!
                                                            .withOpacity(0.5)
                                                        : Colors.black
                                                            .withOpacity(0.5),
                                                  ))
                                            ]),
                                        style: const TextStyle().copyWith(
                                            color: controller.qualityGroupValue
                                                        .value ==
                                                    quality
                                                ? primaryColor
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
                                    activeColor: primaryColor,
                                    title: Text("Normal",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 4
                                                    ? primaryColor
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
                                                    ? primaryColor
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = val!;
                                      controller.controller
                                          .setPlaybackSpeed(0.5);
                                    },
                                    activeColor: primaryColor,
                                    value: 2,
                                    groupValue: controller.playback.value,
                                    title: Text("0.5x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 2
                                                    ? primaryColor
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
                                    activeColor: primaryColor,
                                    title: Text("0.75x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 3
                                                    ? primaryColor
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
                                    activeColor: primaryColor,
                                    title: Text("1.25x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 5
                                                    ? primaryColor
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
                                    activeColor: primaryColor,
                                    title: Text("1.5x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 6
                                                    ? primaryColor
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
                                    activeColor: primaryColor,
                                    title: Text("1.75x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 7
                                                    ? primaryColor
                                                    : Colors.black)),
                                  ),
                                  RadioListTile(
                                    onChanged: (val) {
                                      controller.playback.value = 8;
                                      controller.controller.setPlaybackSpeed(2);
                                    },
                                    groupValue: controller.playback.value,
                                    value: 8,
                                    activeColor: primaryColor,
                                    title: Text("2x",
                                        style: TextStyle(
                                            color:
                                                controller.playback.value == 8
                                                    ? primaryColor
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '/video_player_controller.dart';

// ignore: must_be_immutable
class Popup extends StatelessWidget {
  Popup({Key? key, this.kColorWhite, this.kColorPrimary, this.kColorBlack})
      : super(key: key);
  final Color? kColorWhite;
  final Color? kColorPrimary;
  final Color? kColorBlack;
  VideoPlayerSreenController controller =
      Get.find<VideoPlayerSreenController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      // padding: EdgeInsets.only(left: 24 right: ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom, top: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      height: 402,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Settings".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 24),
                    // color: Colors.white,
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  "assets/icons/cross.svg",
                  width: 25,
                  height: 25,
                  package: "youtube_video_player",
                  // color: Colors.white,
                )).paddingOnly(right: 20)
          ],
        ),
        const SizedBox(height: 15),
        TabBar(
          labelColor: kColorPrimary,
          unselectedLabelColor: kColorWhite,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          indicatorColor: Colors.white,
          indicator: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage("assets/icons/indicator.png",
                      package: "youtube_video_player"))),
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
          height: 220,
          child: TabBarView(
            controller: controller.tabController,
            children: [
              SingleChildScrollView(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.qualities.map((element) {
                      var quality = element.qualityLabel == "144p"
                          ? "Low "
                          : element.qualityLabel == "240p"
                              ? "Low "
                              : element.qualityLabel == "360p"
                                  ? "SD "
                                  : element.qualityLabel == "480p"
                                      ? "SD "
                                      : element.qualityLabel == "720p"
                                          ? "HD "
                                          : "Full HD ";
                      quality += "upto ${element.qualityLabel}";
                      return RadioListTile(
                          // onPressed: () {},
                          controlAffinity: ListTileControlAffinity.leading,
                          groupValue: controller.qualityGroupValue.value,
                          onChanged: (val) {
                            controller.qualityGroupValue.value = val!;
                            Duration position =
                                controller.controller.value.position;
                            controller.controller.pause();
                            Get.back();
                            controller.isInitialized.value = false;
                            controller.isPlaying.value = false;
                            controller.controller =
                                VideoPlayerController.networkUrl(element.url,
                                    videoPlayerOptions: VideoPlayerOptions())
                                  ..initialize().then((value) {
                                    controller.controller.seekTo(position);
                                    controller.isInitialized.value = true;
                                    controller.controller.play();
                                    controller.isPlaying.value = true;
                                  });
                            controller.controller.addListener(() {
                              controller.position.value =
                                  controller.controller.value.position;
                              controller.sliderVal.value =
                                  controller.position.value.inSeconds /
                                      controller.duration.value.inSeconds;
                            });
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          activeColor: kColorPrimary,
                          value: quality,
                          title: Text.rich(
                            TextSpan(
                                text: element.qualityLabel == "144p"
                                    ? "Low "
                                    : element.qualityLabel == "240p"
                                        ? "Low "
                                        : element.qualityLabel == "360p"
                                            ? "SD "
                                            : element.qualityLabel == "480p"
                                                ? "SD "
                                                : element.qualityLabel == "720p"
                                                    ? "HD "
                                                    : "Full HD ",
                                children: [
                                  TextSpan(
                                    text: "upto ${element.qualityLabel}",
                                  )
                                ]),
                          ));
                    }).toList(),
                    // children: [
                    //   RadioListTile(
                    //       // onPressed: () {},
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       groupValue: controller.qualityGroupValue.value,
                    //       onChanged: (val) {
                    //         controller.qualityGroupValue.value = val!;
                    //       },
                    //       visualDensity: const VisualDensity(
                    //           vertical: VisualDensity.minimumDensity,
                    //           horizontal: VisualDensity.minimumDensity),
                    //       activeColor: kColorPrimary,
                    //       value: "Full HD upto 1080p",
                    //       title: Text.rich(
                    //         TextSpan(text: "Full HD ", children: [
                    //           TextSpan(
                    //               text: "upto 1080p",
                    //               style: kTextStylePoppinsMedium.copyWith(
                    //                 fontWeight: FontWeight.w300,
                    //                 color: controller.qualityGroupValue.value ==
                    //                         "Full HD upto 1080p"
                    //                     ? kColorPrimary.withOpacity(0.5)
                    //                     : Colors.black.withOpacity(0.5),
                    //               ))
                    //         ]),
                    //         style: kTextStylePoppinsRegular.copyWith(
                    //             color: controller.qualityGroupValue.value ==
                    //                     "Full HD upto 1080p"
                    //                 ? kColorPrimary
                    //                 : Colors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600),
                    //       )),
                    //   RadioListTile(
                    //       // onPressed: () {},
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       groupValue: controller.qualityGroupValue.value,
                    //       onChanged: (val) {
                    //         controller.qualityGroupValue.value = val!;
                    //       },
                    //       visualDensity: const VisualDensity(
                    //           vertical: VisualDensity.minimumDensity,
                    //           horizontal: VisualDensity.minimumDensity),
                    //       activeColor: kColorPrimary,
                    //       value: "HD upto 720p",
                    //       title: Text.rich(
                    //         TextSpan(text: "HD ", children: [
                    //           TextSpan(
                    //               text: "upto 720p",
                    //               style: kTextStylePoppinsMedium.copyWith(
                    //                 fontWeight: FontWeight.w300,
                    //                 color: controller.qualityGroupValue.value ==
                    //                         "HD upto 720p"
                    //                     ? kColorPrimary.withOpacity(0.5)
                    //                     : Colors.black.withOpacity(0.5),
                    //               ))
                    //         ]),
                    //         style: kTextStylePoppinsRegular.copyWith(
                    //             color: controller.qualityGroupValue.value ==
                    //                     "HD upto 720p"
                    //                 ? kColorPrimary
                    //                 : Colors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600),
                    //       )),
                    //   RadioListTile(
                    //       // onPressed: () {},
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       groupValue: controller.qualityGroupValue.value,
                    //       onChanged: (val) {
                    //         controller.qualityGroupValue.value = val!;
                    //       },
                    //       visualDensity: const VisualDensity(
                    //           vertical: VisualDensity.minimumDensity,
                    //           horizontal: VisualDensity.minimumDensity),
                    //       activeColor: kColorPrimary,
                    //       value: "SD upto 480p",
                    //       title: Text.rich(
                    //         TextSpan(text: "SD ", children: [
                    //           TextSpan(
                    //               text: "upto 480p",
                    //               style: kTextStylePoppinsMedium.copyWith(
                    //                 fontWeight: FontWeight.w300,
                    //                 color: controller.qualityGroupValue.value ==
                    //                         "SD upto 480p"
                    //                     ? kColorPrimary.withOpacity(0.5)
                    //                     : Colors.black.withOpacity(0.5),
                    //               ))
                    //         ]),
                    //         style: kTextStylePoppinsRegular.copyWith(
                    //             color: controller.qualityGroupValue.value ==
                    //                     "SD upto 480p"
                    //                 ? kColorPrimary
                    //                 : Colors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600),
                    //       )),
                    //   RadioListTile(
                    //       // onPressed: () {},
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       groupValue: controller.qualityGroupValue.value,
                    //       onChanged: (val) {
                    //         controller.qualityGroupValue.value = val!;
                    //       },
                    //       visualDensity: const VisualDensity(
                    //           vertical: VisualDensity.minimumDensity,
                    //           horizontal: VisualDensity.minimumDensity),
                    //       activeColor: kColorPrimary,
                    //       value: "Low Data Saver",
                    //       title: Text.rich(
                    //         TextSpan(text: "Low ", children: [
                    //           TextSpan(
                    //               text: "Data Saver",
                    //               style: kTextStylePoppinsMedium.copyWith(
                    //                 fontWeight: FontWeight.w300,
                    //                 color: controller.qualityGroupValue.value ==
                    //                         "Low Data Saver"
                    //                     ? kColorPrimary.withOpacity(0.5)
                    //                     : Colors.black.withOpacity(0.5),
                    //               ))
                    //         ]),
                    //         style: kTextStylePoppinsRegular.copyWith(
                    //             color: controller.qualityGroupValue.value ==
                    //                     "Low Data Saver"
                    //                 ? kColorPrimary
                    //                 : Colors.black,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w600),
                    //       )),
                    //   SizedBox(
                    //     height: 20,
                    //   )
                    // ],
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
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          groupValue: controller.playback.value,
                          value: 4,
                          activeColor: kColorPrimary,
                          title: Text(
                            "Normal",
                            style: TextStyle(
                              color: controller.playback.value == 4
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.controller.setPlaybackSpeed(0.25);
                            controller.playback.value = val!;
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          value: 1,
                          activeColor: kColorPrimary,
                          groupValue: controller.playback.value,
                          title: Text(
                            "0.25x",
                            style: TextStyle(
                              color: controller.playback.value == 1
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.playback.value = val!;
                            controller.controller.setPlaybackSpeed(0.5);
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          activeColor: kColorPrimary,
                          value: 2,
                          groupValue: controller.playback.value,
                          title: Text(
                            "0.5x",
                            style: TextStyle(
                              color: controller.playback.value == 2
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.playback.value = 3;
                            controller.controller.setPlaybackSpeed(0.75);
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          groupValue: controller.playback.value,
                          value: 3,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: kColorPrimary,
                          title: Text(
                            "0.75x",
                            style: TextStyle(
                              color: controller.playback.value == 3
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.controller.setPlaybackSpeed(1.25);
                            controller.playback.value = 5;
                          },
                          groupValue: controller.playback.value,
                          value: 5,
                          activeColor: kColorPrimary,
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          title: Text(
                            "1.25x",
                            style: TextStyle(
                              color: controller.playback.value == 5
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.playback.value = 6;
                            controller.controller.setPlaybackSpeed(1.5);
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          groupValue: controller.playback.value,
                          value: 6,
                          activeColor: kColorPrimary,
                          title: Text(
                            "1.5x",
                            style: TextStyle(
                              color: controller.playback.value == 6
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.playback.value = 7;
                            controller.controller.setPlaybackSpeed(1.75);
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          groupValue: controller.playback.value,
                          value: 7,
                          activeColor: kColorPrimary,
                          title: Text(
                            "1.75x",
                            style: TextStyle(
                              color: controller.playback.value == 7
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      RadioListTile(
                          onChanged: (val) {
                            controller.playback.value = 8;
                            controller.controller.setPlaybackSpeed(2);
                          },
                          visualDensity: const VisualDensity(
                              vertical: VisualDensity.minimumDensity,
                              horizontal: VisualDensity.minimumDensity),
                          groupValue: controller.playback.value,
                          value: 8,
                          activeColor: kColorPrimary,
                          title: Text(
                            "2x",
                            style: TextStyle(
                              color: controller.playback.value == 8
                                  ? kColorPrimary
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
              // Obx(
              //   () => SingleChildScrollView(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         RadioListTile(
              //             onChanged: (val) {
              //               controller.caption.clear();
              //               controller.subVal.value = 0;
              //             },
              //             activeColor: kColorPrimary,
              //             groupValue: controller.subVal.value,
              //             value: 0,
              //             title: Text("Off",
              //                 style: TextStyle(
              //                     color: controller.subVal.value == 0
              //                         ? kColorPrimary
              //                         : Colors.black))),
              //         RadioListTile(
              //             onChanged: (val) async {
              //               List srtFile = await controller.getCloseCaptionFile(
              //                   "https://www.capitalcaptions.com/wp-content/uploads/2017/04/How-to-Write-.SRT-Subtitles-for-Video.srt");
              //               const AsyncSnapshot.waiting();
              //               controller.caption.value = srtFile;
              //               controller.subVal.value = 1;
              //             },
              //             activeColor: kColorPrimary,
              //             groupValue: controller.subVal.value,
              //             value: 1,
              //             title: Text(" English",
              //                 style: TextStyle(
              //                     color: controller.subVal.value == 1
              //                         ? kColorPrimary
              //                         : Colors.black))),
              //         RadioListTile(
              //             onChanged: (val) async {
              //               List srtFile = await controller.getCloseCaptionFile(
              //                   "https://www.opensubtitles.com/download/0FA942092B1481920346D1129A8032CB73A6F88F67FD9D992A972315AE7ECAB837966AD79EE0D4953CFAB836FA4853623D4720E6FACF4A9B8DE3FA61F8E28FACA49513E2ED2EF0463560DF984095B5A95230973DED740BAA4FBD54CB39920527A0075D5E10426FB668F598A7FBD6C82382B54CF205BA222FFBA48C2498FBABAC1DE250E823D4E28E13925C097C752BB91435E9F92295EB6B46C97FDFC44C55788003C3AF9749C24505BEFFF51DAE16073664DD461A273E7CE7CA698FB3AB61982A440E87A5BD29D6AD3298EEEBC0E5143B0531643028194B6451C9D29123EB795387F0CB9770204D78E06760ED0F11D04EAB5838E79B28EC956564DE49639DE56D72CFE22A469AA5B94D2159DC2D6C928F96071E6D0CE87F76F10437AB0F5F78/subfile/Egoist.2023.1080p.U-NEXT.WEB-DL.X264-XRES.otoka_sub-018-chi_sim.en.srt");
              //               const AsyncSnapshot.waiting();
              //               controller.caption.value = srtFile;
              //               controller.subVal.value = 2;
              //             },
              //             activeColor: kColorPrimary,
              //             groupValue: controller.subVal.value,
              //             value: 2,
              //             title: Text("Hindi",
              //                 style: TextStyle(
              //                     color: controller.subVal.value == 2
              //                         ? kColorPrimary
              //                         : Colors.black))),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        )
      ]),
    );
  }
}

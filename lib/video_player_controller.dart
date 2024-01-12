import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:screen_brightness/screen_brightness.dart';
import 'package:subtitle/subtitle.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoPlayerSreenController extends GetxController
    with GetTickerProviderStateMixin {
  VideoPlayerSreenController({required this.link});
  final String link;
  // final String link =
  //     "https://archive.org/download/srimad-devi-bhagavatam-raja-visuddhi-dharmasar/Srimad%20Devi%20Bha%CC%84gavatam%201.5.1%E2%80%94%20Story%20of%20Hayagri%CC%84va.mp4";
  late VideoPlayerController controller;
  var position = const Duration(seconds: 0).obs;
  var duration = const Duration(seconds: 0).obs;
  RxBool isPlaying = false.obs;
  var sliderVal = 0.0.obs;
  var isVisible = true.obs;
  final setBrightness = 1.0.obs;
  var isMute = false.obs;
  final setVolumeValue = 1.0.obs;
  var volVisible = false.obs;
  var brightVisible = false.obs;
  late TabController tabController;
  Video? video;
  var playback = 4.obs;
  var caption = [].obs;
  var subVal = 0.obs;
  RxList<MuxedStreamInfo> qualities = <MuxedStreamInfo>[].obs;
  var qualityGroupValue = "Full HD upto 1080p".obs;
  Subtitle? currentSubtitle;
  var yt = YoutubeExplode();
  StreamManifest? manifest;
  var isInitialized = false.obs;
  // Rx<Result> videoDetails = Result().obs;

  Duration durationRangeToDuration(List<DurationRange> buffered) {
    Duration totalDuration = Duration.zero;
    Duration prevEnd = buffered.first.start;
    for (final range in buffered) {
      // Check if ranges overlap
      final overlap = prevEnd.compareTo(range.start);

      // Adjust for overlap
      if (overlap <= 0) {
        // totalDuration += range.start;
      } else {
        totalDuration += range.end - prevEnd;
      }

      prevEnd = range.end;
    }
    return totalDuration;
  }

  getUrls(String url) async {
    manifest =
        await yt.videos.streamsClient.getManifest(getYouTubeVideoId(url));
  }

  @override
  void onInit() async {
    log("init state called");
    // videoDetails.value = Get.arguments;
    // log(videoDetails.value.title!);
    // print(videoDetails.value.link);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    manifest =
        await yt.videos.streamsClient.getManifest(getYouTubeVideoId(link));
    video = await yt.videos.get(getYouTubeVideoId(link));
    qualities.value = manifest!.muxed.toList();
    if (manifest!.muxed.toList().first.qualityLabel == '144p') {
      qualities.remove(manifest!.muxed.toList().first);
    }
    MuxedStreamInfo streamInfo = manifest!.muxed.bestQuality;
    var url = streamInfo.url;
    controller = VideoPlayerController.networkUrl(
      url,
      videoPlayerOptions: VideoPlayerOptions(),
    )..initialize().then((value) {
        position.value = controller.value.position;
        duration.value = controller.value.duration;
        isInitialized.value = true;
        controller.play();
        isPlaying.value = true;
      });
    controller.addListener(() async {
      position.value = controller.value.position;
      sliderVal.value = position.value.inSeconds / duration.value.inSeconds;
    });

    controller.setLooping(true);
    tabController = TabController(length: 2, vsync: this);
    ScreenBrightness()
        .current
        .then((brightness) => setBrightness.value = brightness);

    setVolumeValue.value = controller.value.volume;
    setVolumeValue.value == 0 ? isMute.value = true : isMute.value = false;
    controller.addListener(() {
      if (caption.isNotEmpty) {
        currentSubtitle = getSubtitleForCurrentPosition(position.value);
        // print("---->${currentSubtitle!.data}");
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    controller.pause();
    controller.dispose();
    super.onClose();
  }

  String getYouTubeVideoId(String url) {
    final List data = url.split("v=");
    return data[1];
  }

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
            ? '00'
            : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
            ? '00'
            : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
            ? '00'
            : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  Future<List> getCloseCaptionFile(url) async {
    try {
      final data = await http.get(Uri.parse(url));
      final srtContent = data.body.toString().trim();
      var lines = srtContent.split('\n');
      // var subtitles = <String, String>{};
      // print("---->${lines.length}");
      List<Subtitle> subtitles = [];
      int index = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        if (line.isEmpty) {
          continue;
        }

        if (int.tryParse(line) != null) {
          index = int.parse(line);
        } else if (line.contains('-->')) {
          final parts = line.split(' --> ');
          final start = parseDuration(parts[0]);
          final end = parseDuration(parts[1]);

          var data = lines[++i].trim();
          var j = i + 1;
          if (lines[j].isNotEmpty) {
            data += " ${lines[++i]}";
          }
          subtitles
              .add(Subtitle(index: index, start: start, end: end, data: data));
          // print("---->${subtitles.length}");
        }
        // print("---->${subtitles.length}");
      }
      return subtitles;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int seconds;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = (double.parse(parts[parts.length - 1].split(",")[0])).round();
    // print("----->$hours $minutes $seconds");
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Subtitle? getSubtitleForCurrentPosition(Duration position) {
    // print("----->${caption.value.length}");
    // ignore: invalid_use_of_protected_member
    for (var subtitle in caption.value) {
      // print("----->${subtitle.start}---${subtitle.end}");
      if (position >= subtitle.start && position <= subtitle.end) {
        return subtitle;
      }
    }
    return null;
  }
}

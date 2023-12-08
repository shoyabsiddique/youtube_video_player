# Flutter YouTube Player

A Flutter package for embedding a YouTube player with customizable controls and features.

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_youtube_player: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package in your Dart code:

```dart
import 'package:flutter_youtube_player/flutter_youtube_player.dart';
```

Use the `PotraitPlayer` widget to embed a YouTube player in your app:

```dart
PotraitPlayer(
  link: 'YOUR_YOUTUBE_VIDEO_URL',
  aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
  kColorWhite: Colors.white, // Optional: Customize color themes
  kColorPrimary: Colors.orange,
  kColorBlack: Colors.black,
);
```

### Parameters

- `link`: The YouTube video URL.
- `aspectRatio`: The aspect ratio of the player.
- `kColorWhite`: (Optional) Color for elements with a white background.
- `kColorPrimary`: (Optional) Primary color for buttons and progress bars.
- `kColorBlack`: (Optional) Color for elements with a black background.

### Features

- **Play/Pause Controls**: Tap on the video to toggle play/pause. Additional play/pause button available.
- **Brightness Control**: Swipe vertically on the left side of the video to adjust brightness.
- **Volume Control**: Swipe vertically on the right side of the video to adjust volume.
- **Seek Controls**: Seek forward and backward by tapping on the respective buttons.
- **Fullscreen**: Tap on the fullscreen button to switch to landscape mode.
- **Settings Popup**: Tap on the settings button to access additional settings.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_youtube_player/flutter_youtube_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('YouTube Player Example'),
        ),
        body: PotraitPlayer(
          link: 'YOUR_YOUTUBE_VIDEO_URL',
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Replace `YOUR_YOUTUBE_VIDEO_URL` with the actual YouTube video URL you want to play. Additionally, consider adding more sections to the README, such as "Contributing," "Issues," and "Changelog," based on your project's needs.

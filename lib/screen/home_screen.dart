import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  // bool showVideoPlayer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video != null
          ? _VideoPlayer(
              video: video!,
              onAnotherVideoPressed: onLogoTap,
            )
          : _VideoSelector(onLogoTap: onLogoTap),
    );
  }

  onLogoTap() async {
    video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    setState(() {
      this.video = video;
    });

    // print(video);
  }
}

///ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

class _VideoSelector extends StatefulWidget {
  final VoidCallback onLogoTap;
  const _VideoSelector({
    super.key,
    required this.onLogoTap,
  });

  @override
  State<_VideoSelector> createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<_VideoSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff2a3a7c),
            Color(0xff000118),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: widget.onLogoTap,
          ),
          SizedBox(height: 32.0),
          _Title(),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'asset/image/logo.png',
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 32.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

///ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

class _VideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onAnotherVideoPressed;

  const _VideoPlayer({
    super.key,
    required this.video,
    required this.onAnotherVideoPressed,
  });

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  bool showIcons = true;
  Timer? _timeoutTimer;

  /// 1번 - 최초 실행 시 타이머 작동
  /// 2번 - 화면 눌러서 아이콘 show 되면 타이머 작동
  /// 없/ 생, 없 / 생, 없

  readTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        showIcons = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    initialController();

    readTimer();
  }

  @override
  didUpdateWidget(covariant _VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initialController();
    }
  }

  initialController() async {
    videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoPlayerController.initialize();

    videoPlayerController.addListener(() {
      setState(() {});
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showIcons = !showIcons;
        });
        _timeoutTimer?.cancel();
        //버튼 누르면
        readTimer();
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                videoPlayerController,
              ),
              if (showIcons)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              if (showIcons)
                _PlayButton(
                  onReversePressed: onReversePressed,
                  onPlayPressed: onPlayPressed,
                  onForwardPressed: onForwardPressed,
                  isPlaying: videoPlayerController.value.isPlaying,
                ),
              if (showIcons)
                _Bottom(
                  position: videoPlayerController.value.position,
                  maxPosition: videoPlayerController.value.duration,
                  onSliderChanged: onSliderChanged,
                ),
              if (showIcons)
                _AnotherVideo(
                  onAnotherVideoPressed: widget.onAnotherVideoPressed,
                ),
            ],
          ),
        ),
      ),
    );
  }

  onReversePressed() {
    final currentPosition = videoPlayerController.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoPlayerController.seekTo(position);
  }

  onPlayPressed() {
    setState(() {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
    });
  }

  onForwardPressed() {
    final maxPosition = videoPlayerController.value.duration;
    final currentPosition = videoPlayerController.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoPlayerController.seekTo(position);
  }

  onSliderChanged(double val) {
    final position = Duration(milliseconds: val.toInt());

    videoPlayerController.seekTo(position);
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onReversePressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _PlayButton({
    super.key,
    required this.onReversePressed,
    required this.onPlayPressed,
    required this.onForwardPressed,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: onReversePressed,
            icon: Icon(Icons.rotate_left),
            color: Colors.white,
          ),
          IconButton(
            onPressed: onPlayPressed,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            color: Colors.white,
          ),
          IconButton(
            onPressed: onForwardPressed,
            icon: Icon(Icons.rotate_right),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final Duration position;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  const _Bottom({
    super.key,
    required this.position,
    required this.maxPosition,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: [
            Text(
              '${position.inMinutes.toString().padLeft(2, '0')}'
              ':'
              '${(position.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Slider(
                value: position.inMilliseconds.toDouble(),
                max: maxPosition.inMilliseconds.toDouble(),
                onChanged: onSliderChanged,
              ),
            ),
            Text(
              '${maxPosition.inMinutes.toString().padLeft(2, '0')}'
              ':'
              '${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnotherVideo extends StatelessWidget {
  final VoidCallback onAnotherVideoPressed;

  const _AnotherVideo({
    super.key,
    required this.onAnotherVideoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onAnotherVideoPressed,
        icon: Icon(Icons.photo_camera_back),
        color: Colors.white,
      ),
    );
  }
}

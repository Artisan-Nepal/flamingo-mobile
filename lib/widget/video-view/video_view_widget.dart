import 'package:flamingo/shared/enum/enum.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoViewWidget extends StatefulWidget {
  const VideoViewWidget(
      {super.key,
      required this.url,
      this.coverParent = false,
      this.loaderColor = AppColors.black,
      this.behaviour = VideoViewBehaviour.holdToPause});

  final String url;
  final bool coverParent;
  final Color loaderColor;
  final VideoViewBehaviour behaviour;

  @override
  State<VideoViewWidget> createState() => _VideoViewWidgetState();
}

class _VideoViewWidgetState extends State<VideoViewWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  late Future initializeVideoPlayer;
  bool _isPlaying = true;

  _playVideo() {
    _isPlaying = true;
    videoPlayerController.play();
    setState(() {});
  }

  _pauseVideo() {
    _isPlaying = false;
    videoPlayerController.pause();
    setState(() {});
  }

  _toggleVideoPlaying() {
    _isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
    _isPlaying = !_isPlaying;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    initializeVideoPlayer = videoPlayerController.initialize();
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: initializeVideoPlayer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return VisibilityDetector(
            key: ValueKey(widget.url),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction == 1.0) {
                videoPlayerController.seekTo(Duration.zero);
                _playVideo();
              } else {
                _pauseVideo();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video player
                Center(
                  child: GestureDetector(
                    onLongPressDown: (details) {
                      if (widget.behaviour.isHoldToPause)
                        videoPlayerController.pause();
                    },
                    onLongPressUp: () {
                      if (widget.behaviour.isHoldToPause)
                        videoPlayerController.play();
                    },
                    onTapUp: (details) {
                      if (widget.behaviour.isHoldToPause)
                        videoPlayerController.play();
                    },
                    onTap: () {
                      if (widget.behaviour.isPausable) {
                        _toggleVideoPlaying();
                      }
                    },
                    child: widget.coverParent
                        ? SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: videoPlayerController.value.size.width,
                                height: videoPlayerController.value.size.height,
                                child: VideoPlayer(videoPlayerController),
                              ),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio:
                                videoPlayerController.value.aspectRatio,
                            child: Builder(
                              builder: (context) {
                                return VideoPlayer(videoPlayerController);
                              },
                            ),
                          ),
                  ),
                ),
                // play button
                if (widget.behaviour.isPausable)
                  IconButton(
                    onPressed: _toggleVideoPlaying,
                    icon: Icon(
                      Icons.play_arrow,
                      color: AppColors.white.withOpacity(0.5),
                      size: _isPlaying ? 0 : 60,
                    ),
                  ),
              ],
            ),
          );
        } else {
          return DefaultScreenLoaderWidget(
            color: widget.loaderColor,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

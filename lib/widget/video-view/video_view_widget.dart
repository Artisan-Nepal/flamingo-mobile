import 'package:flamingo/shared/enum/enum.dart';
import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoViewWidget extends StatefulWidget {
  const VideoViewWidget({
    super.key,
    required this.url,
    this.coverParent = false,
    this.loaderColor = AppColors.white,
    this.behaviour = VideoViewBehaviour.holdToPause,
    this.looping = true,
    this.onProgress,
    this.onVideoEnd,
  });

  final String url;
  final bool coverParent;
  final Color loaderColor;
  final VideoViewBehaviour behaviour;
  final bool looping;
  final void Function(double progress)? onProgress;
  final VoidCallback? onVideoEnd;

  @override
  State<VideoViewWidget> createState() => _VideoViewWidgetState();
}

class _VideoViewWidgetState extends State<VideoViewWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  late Future initializeVideoPlayer;
  bool _isPlaying = true;
  bool _hasEnded = false;

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

  void _onPositionChanged() {
    final value = videoPlayerController.value;
    if (!value.isInitialized || value.duration.inMilliseconds == 0) return;

    widget.onProgress?.call(
      (value.position.inMilliseconds / value.duration.inMilliseconds)
          .clamp(0.0, 1.0),
    );

    if (!widget.looping &&
        !_hasEnded &&
        value.position >= value.duration - const Duration(milliseconds: 200)) {
      _hasEnded = true;
      widget.onVideoEnd?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    initializeVideoPlayer = videoPlayerController.initialize();
    videoPlayerController.setLooping(widget.looping);
    videoPlayerController.addListener(_onPositionChanged);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.removeListener(_onPositionChanged);
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
              if (widget.behaviour.isHoldToPause) {
                if (info.visibleFraction == 1.0) {
                  videoPlayerController.seekTo(Duration.zero);
                  _playVideo();
                } else {
                  _pauseVideo();
                }
              } else {
                if (info.visibleFraction == 0.0) {
                  _pauseVideo();
                } else {
                  _playVideo();
                }
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

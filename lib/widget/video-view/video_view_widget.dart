import 'package:flamingo/shared/util/util.dart';
import 'package:flamingo/widget/loader/default_screen_loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoViewWidget extends StatefulWidget {
  const VideoViewWidget({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<VideoViewWidget> createState() => _VideoViewWidgetState();
}

class _VideoViewWidgetState extends State<VideoViewWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  late Future initializeVideoPlayer;

  _playVideo() {
    videoPlayerController.play();
  }

  _pauseVideo() {
    videoPlayerController.pause();
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
                      videoPlayerController.pause();
                    },
                    onLongPressUp: () {
                      videoPlayerController.play();
                    },
                    onTap: () {},
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      child: Builder(
                        builder: (context) {
                          return VideoPlayer(videoPlayerController);
                        },
                      ),
                    ),
                  ),
                ),
                // play button
              ],
            ),
          );
        } else {
          return DefaultScreenLoaderWidget(
            color: AppColors.white,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

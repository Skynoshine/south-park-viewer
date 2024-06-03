import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:myapp/screen/video/video_controller.dart';
import 'package:myapp/services/drive/drive_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:myapp/services/drive/video_html.dart' as embed;

class VideoScreen extends StatefulWidget {
  final String episode;
  final String season;

  const VideoScreen({super.key, required this.episode, required this.season});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ct = VideoController();
  Timer timeInPage = Timer(const Duration(seconds: 3), () {});

  @override
  void initState() {
    super.initState();
    _fetchVideosFromDrive();
    ct.setFullscreenMode;
    ct.setInitialOrientation(context);
  }

  Future<void> _fetchVideosFromDrive() async {
    try {
      List<Map<String, String>> content = await DriveController()
          .fetchFilesFromSpecificSubFolder(
              ct.apiKey, ct.folderId, widget.season);
      await ct.lastEpisodeViewed(widget.episode);
      ct.lastEpisodeView = await ct.cache.get(ct.cacheKey);
      setState(() {
        ct.videoData = content;
        ct.videoId = DriveController()
            .getVideoIdForEpisode(widget.episode, ct.videoData);
        ct.isLoading = false;

        Logger().e(ct.lastEpisodeView);
      });
    } catch (e) {
      Logger().e('Error fetching videos: $e');
      setState(() {
        ct.isLoading = false;
      });
    }
  }

  void _toggleAppBarVisibility() {
    setState(() {
      ct.showAppBar = !ct.showAppBar;
    });

    if (ct.showAppBar) {
      ct.hideAppBarTimer?.cancel();
      ct.hideAppBarTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          ct.showAppBar = false;
        });
      });
    }
  }

  @override
  void dispose() {
    ct.hideAppBarTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAppBarVisibility,
      child: SafeArea(
        child: Scaffold(
          appBar: ct.showAppBar
              ? AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              : null,
          body: ct.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ct.videoId == null
                  ? const Center(child: Text('Content not found'))
                  : WebViewWidget(
                      controller: WebViewController()
                        ..loadHtmlString(embed.htmlContent(ct.videoId!))
                        ..setJavaScriptMode(JavaScriptMode.unrestricted),
                    ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/services/drive/drive_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:myapp/services/video_html.dart' as embed;

class VideoScreen extends StatefulWidget {
  final String episode;

  const VideoScreen({super.key, required this.episode});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final String apiKey = 'INSERT_YOU_KEY_HERE';
  final String folderId = '1QKcyJGJXrewd3We8utC4CyeUmHirHCyL';
  List<Map<String, String>> videoData = [];

  @override
  void initState() {
    super.initState();
    _fetchVideosFromDrive();
  }

  Future<void> _fetchVideosFromDrive() async {
    try {
      List<Map<String, String>> content =
          await DriveController().fetchDrive(apiKey, folderId);
      setState(() {
        videoData = content;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoId =
        DriveController().getVideoIdForEpisode(widget.episode, videoData);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: videoId == null
            ? const Center(child: Text('Video not found'))
            : WebViewWidget(
                controller: WebViewController()
                  ..loadHtmlString(embed.htmlContent(videoId))
                  ..setJavaScriptMode(JavaScriptMode.unrestricted),
              ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/services/cache/local_cache.dart';

class VideoController {
  final String cacheKey = 'last_episode';
  final LocalCache cache = LocalCache();
  List<Map<String, String>> videoData = [];
  bool isLoading = true;
  String? videoId;
  bool showAppBar = false;
  Timer? hideAppBarTimer;
  final String apiKey = 'YOUR_API_KEY';
  final String folderId = '1Phf33_WkxOHhYAKeNVSTdvhT2jK4n9AA';
  List<String>? lastEpisodeView;

  void setFullscreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  Future<List<String>?> lastEpisodeViewed(String episode) async {
    await cache.clear(cacheKey);
    await cache.put(cacheKey, [episode]);
    return [episode];
  }

  void setInitialOrientation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
      }
    });
  }
}

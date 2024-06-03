import 'package:flutter/material.dart';
import 'package:myapp/screen/video/video_controller.dart';
import 'package:myapp/services/cache/local_cache.dart';
import 'package:myapp/services/webscrap/episode_entity.dart';
import 'package:myapp/services/webscrap/webscrap.dart';

class HomeController {
  final VideoController videoController = VideoController();
  final cache = LocalCache();
  String selectedSeason = '1';
  List<String> watch = [];
  final String watchKey = 'watch';

  Future<EpisodeEntity> fetchData() async {
    return await Webscrap().southParkStudios(season: selectedSeason);
  }

  Future<String> selectedFormatedSeason(String file) async {
    final formattedEpisode =
        file.replaceAll('T', '').replaceAll('E', '').replaceAll(' • ', 'e');
    final format = formattedEpisode.split('e')[0].padLeft(1);
    return format;
  }

  Future<List<String>?> watching(String key) async {
    return await cache.get(key);
  }

  Future<void> markAsWatch(List<String> titles) async {
    watch = titles;
    await cache.put(watchKey, titles);
  }

  Future<void> markAsUnwatch(String title) async {
    await cache.delete(watchKey, title);
  }

  Future<void> markAllUnwatch() async {
    await cache.clear(watchKey);
  }

  List<DropdownMenuItem<String>> buildSeasonItems() {
    return List<DropdownMenuItem<String>>.generate(
      26,
      (index) => DropdownMenuItem(
        value: (index + 1).toString(),
        child: Text('Season ${index + 1}'),
      ),
    );
  }
}

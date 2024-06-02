import 'package:http/http.dart' as http;
import 'dart:convert';

class DriveController {
  Future<List<Map<String, String>>> fetchDrive(
      String apiKey, String folderId) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/drive/v3/files?q="$folderId"+in+parents&fields=files(id,name)&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> files = data['files'];

      return files
          .map((file) =>
              {'id': file['id'].toString(), 'title': file['name'].toString()})
          .toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  List<String> extractSeasonAndEpisode(String fileName) {
    RegExp regExp = RegExp(r'[sS](\d+)[eE](\d+)');
    Match? match = regExp.firstMatch(fileName);
    String season = match != null ? match.group(1) ?? '' : '';
    String episode = match != null ? match.group(2) ?? '' : '';
    return [season, episode];
  }

  String? getVideoIdForEpisode(
      String episode, List<Map<String, String>> videoData) {
    String formattedEpisode =
        episode.replaceAll('T', '').replaceAll('E', '').replaceAll(' • ', 'e');
    for (var video in videoData) {
      List<String> seasonAndEpisode = extractSeasonAndEpisode(video['title']!);
      if (seasonAndEpisode[0] == formattedEpisode.split('e')[0] &&
          seasonAndEpisode[1] ==
              formattedEpisode.split('e')[1].padLeft(2, '0')) {
        return video['id'];
      }
    }
    return null;
  }
}

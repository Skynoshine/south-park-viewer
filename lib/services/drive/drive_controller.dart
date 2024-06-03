import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class DriveController {
  Future<String?> _fetchSubFolderIdByName(
      String apiKey, String parentFolderId, String folderName) async {
    final uri = Uri.parse(
        'https://www.googleapis.com/drive/v3/files?q="$parentFolderId"+in+parents+and+name="$folderName"+and+mimeType="application/vnd.google-apps.folder"&fields=files(id)&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final folders = data['files'] as List<dynamic>;

      if (folders.isNotEmpty) {
        return folders.first['id'].toString();
      }
    } else {
      throw Exception('Failed to load subfolder');
    }
    return null;
  }

  Future<List<Map<String, String>>> _fetchFiles(
      String apiKey, String folderId) async {
    final uri = Uri.parse(
        'https://www.googleapis.com/drive/v3/files?q="$folderId"+in+parents&fields=files(id,name)&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final files = data['files'] as List<dynamic>;

      Logger().d('Content: $files');
      return files.map((file) {
        return {'id': file['id'].toString(), 'title': file['name'].toString()};
      }).toList();
    } else {
      throw Exception('Failed to load files');
    }
  }

  List<String> extractSeasonAndEpisode(String fileName) {
    final regExp1 = RegExp(r'[sS](\d+)[eE](\d+)');
    final regExp2 = RegExp(r'(\d+)[eE](\d+)');

    final match1 = regExp1.firstMatch(fileName);
    final match2 = regExp2.firstMatch(fileName);

    final season = match1 != null
        ? match1.group(1) ?? ''
        : (match2 != null ? match2.group(1) ?? '' : '');
    final episode = match1 != null
        ? match1.group(2) ?? ''
        : (match2 != null ? match2.group(2) ?? '' : '');

    return [season, episode];
  }

  String? getVideoIdForEpisode(
      String episode, List<Map<String, String>> videoData) {
    final formattedEpisode =
        episode.replaceAll('T', '').replaceAll('E', '').replaceAll(' • ', 'e');
    Logger().d('Formatted Episode: $formattedEpisode');

    for (var video in videoData) {
      final seasonAndEpisode = extractSeasonAndEpisode(video['title']!);
      Logger().d(
          'Checking video: ${video['title']}, Season: ${seasonAndEpisode[0]}, Episode: ${seasonAndEpisode[1]}');

      if (seasonAndEpisode[0] == formattedEpisode.split('e')[0] &&
          seasonAndEpisode[1] ==
              formattedEpisode.split('e')[1].padLeft(2, '0')) {
        Logger().d('Match found: ${video['id']}');
        return video['id'];
      } else if (seasonAndEpisode[0].isEmpty) {
        return video['id'];
      }
    }
    return null;
  }

  Future<List<Map<String, String>>> fetchFilesFromSpecificSubFolder(
      String apiKey, String rootFolderId, String subFolderName) async {
    final subFolderId =
        await _fetchSubFolderIdByName(apiKey, rootFolderId, subFolderName);

    if (subFolderId != null) {
      Logger().d('Search: $subFolderId');
      return await _fetchFiles(apiKey, subFolderId);
    } else {
      throw Exception('Subfolder not found');
    }
  }
}

import 'package:myapp/services/webscrap/episode_entity.dart';
import 'package:myapp/services/webscrap/scraper.dart';
import 'package:myapp/services/webscrap/utils/adorocinema_seasons_url.dart';
import 'package:myapp/services/webscrap/utils/southpark_seasons_url.dart';

class Webscrap {
  Future<EpisodeEntity> southParkStudios({required String season}) async {
    final doc = await Scraper()
        .document(SouthparkStudiosSeasonsUri().getSeasonUrl(int.parse(season)));

    final images = Scraper.docSelecAllAttr(doc, '.content img', 'src');
    final hrefs = Scraper.docSelecAllAttr(
        doc, '.item.full-ep.css-1xgfjmo.e1otv6an0 a', 'href');
    final descriptions = Scraper.docSelecAll(doc, '.deck span');

    List<String> episodes = [];
    final List<String> titles = [];

    List<Map<String, String>> adoroCinema = await _adoroCinema(season);
    episodes.addAll(adoroCinema.map((e) => e['episodeNumber']!));
    titles.addAll(adoroCinema.map((e) => e['title']!));

    if (descriptions.length < episodes.length) {
      descriptions
          .addAll(List.filled(episodes.length - descriptions.length, ''));
    }

    if (images.length < episodes.length) {
      images.addAll(List.filled(episodes.length - images.length, images.first));
    }

    return EpisodeEntity(
      title: titles,
      image: images,
      hrefs: hrefs,
      descriptions: descriptions,
      episodes: episodes,
    );
  }

  Future<List<Map<String, String>>> _adoroCinema(String seasonID) async {
    final doc = await Scraper()
        .document(AdorocinemaSeasonsUrl().getSeasonUrl(int.parse(seasonID)));

    List<Map<String, String>> alternatives =
        Scraper.docSelecAll(doc, '.meta-title span')
            .where((item) => RegExp(r'S\d+E\d+').hasMatch(item))
            .map((item) {
      final episodePattern = RegExp(r'(S(\d+)E(\d+))\s*-\s*(.*)');
      final match = episodePattern.firstMatch(item);

      if (match != null) {
        final season = match.group(2);
        final episode = match.group(3);
        final formattedEpisodeNumber = 'T$season • E$episode';
        final title = match.group(4) ?? '';
        return {'episodeNumber': formattedEpisodeNumber, 'title': title};
      }
      return {'episodeNumber': '', 'title': item};
    }).toList();
    return alternatives;
  }
}

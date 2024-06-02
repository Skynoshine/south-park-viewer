import 'package:myapp/services/episode_entity.dart';
import 'package:myapp/services/scraper.dart';

class Webscrap {
  static String studiosUri(String type) {
    return 'https://www.southparkstudios.com.br/$type/south-park';
  }

  Future<EpisodeEntity> southParkStudios() async {
    await adoroCinema();
    final doc = await Scraper()
        .document('${studiosUri('seasons')}/s6x4l8/temporada-10');
    final titles = Scraper.docSelecAll(doc, '.sub-header h3');
    final images = Scraper.docSelecAllAttr(doc, '.content img', 'src');
    final hrefs = Scraper.docSelecAllAttr(
        doc, '.item.full-ep.css-1xgfjmo.e1otv6an0 a', 'href');
    final descriptions = Scraper.docSelecAll(doc, '.deck span');
    final episodes = Scraper.docSelecAll(doc, '.header h2');

    return EpisodeEntity(
      title: titles,
      image: images,
      hrefs: hrefs,
      descriptions: descriptions,
      episodes: episodes,
    );
  }

  Future<void> adoroCinema() async {
    final doc = await Scraper().document(
        'https://www.adorocinema.com/series/serie-546/temporada-2406/');
    final title = Scraper.docSelecAll(doc, '.meta-title span');
    print(title);
  }
}

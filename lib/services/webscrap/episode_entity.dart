class EpisodeEntity {
  final List<String> title;
  final List<String>? image;
  final List<String>? hrefs;
  final List<String>? descriptions;
  final List<String> episodes;

  EpisodeEntity({
    required this.title,
    required this.image,
    required this.hrefs,
    required this.descriptions,
    required this.episodes,
  });
}

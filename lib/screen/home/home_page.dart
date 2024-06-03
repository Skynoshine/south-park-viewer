import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:myapp/screen/home/controller/home_controller.dart';
import 'package:myapp/screen/home/components/last_viewed_popup.dart';
import 'package:myapp/screen/video/video.dart';
import 'package:myapp/services/webscrap/episode_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController ct = HomeController();
  late Future<EpisodeEntity> _futureData;
  final ValueNotifier<List<String>> _watchedEpisodesNotifier =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _futureData = ct.fetchData();
    _loadWatchedEpisodes();
  }

  Future<void> _loadWatchedEpisodes() async {
    final watchedEpisodes = await ct.watching(ct.watchKey);
    _watchedEpisodesNotifier.value = watchedEpisodes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            LastViewedPopup(
              cache: ct.cache,
              cacheKey: ct.videoController.cacheKey,
              selectedSeason: ct.selectedSeason,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildDropdownButton(),
                  IconButton(
                    onPressed: () {
                      _watchedEpisodesNotifier.value = [];
                      ct.markAllUnwatch();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<EpisodeEntity>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else {
                    return buildEpisodeList(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownButton<String> buildDropdownButton() {
    return DropdownButton<String>(
      value: ct.selectedSeason,
      onChanged: (value) {
        setState(() {
          ct.selectedSeason = value!;
          _futureData = ct.fetchData();
        });
      },
      items: ct.buildSeasonItems().map((item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Container(
            color: item.value == ct.selectedSeason
                ? const Color.fromARGB(37, 33, 149, 243)
                : Colors.transparent,
            child: item.child,
          ),
        );
      }).toList(),
    );
  }

  Widget buildEpisodeList(EpisodeEntity data) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _watchedEpisodesNotifier,
      builder: (context, watchedEpisodes, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: data.title.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final isWatched = watchedEpisodes.contains(data.episodes[index]);
              return buildEpisodeCard(data, index, isWatched);
            },
          ),
        );
      },
    );
  }

  Widget buildEpisodeCard(EpisodeEntity data, int index, bool isWatched) {
    return GestureDetector(
      onTap: () async {
        final episode = data.episodes[index];
        if (!_watchedEpisodesNotifier.value.contains(episode)) {
          _watchedEpisodesNotifier.value =
              List.from(_watchedEpisodesNotifier.value)..add(episode);
          await ct.markAsWatch(_watchedEpisodesNotifier.value);
          Logger().i('Watch: ${await ct.watching(ct.watchKey)}');
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoScreen(
              episode: episode,
              season: ct.selectedSeason,
            ),
          ),
        );
      },
      onLongPress: () async {
        final episode = data.episodes[index];
        if (_watchedEpisodesNotifier.value.contains(episode)) {
          _watchedEpisodesNotifier.value =
              List.from(_watchedEpisodesNotifier.value)..remove(episode);
          await ct.markAsUnwatch(episode);
          Logger().i('Unwatch: ${await ct.watching(ct.watchKey)}');
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: isWatched ? Colors.green : const Color.fromARGB(75, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              data.image![index],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.episodes[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                data.title[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data.descriptions?[index] ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }
}

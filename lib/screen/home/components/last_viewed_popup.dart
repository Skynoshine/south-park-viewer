import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:myapp/screen/home/controller/home_controller.dart';
import 'package:myapp/screen/video/video.dart';
import 'package:myapp/services/cache/local_cache.dart';

class LastViewedPopup extends StatefulWidget {
  final LocalCache cache;
  final String cacheKey;
  final String selectedSeason;

  const LastViewedPopup(
      {super.key,
      required this.cache,
      required this.selectedSeason,
      required this.cacheKey});

  @override
  State<LastViewedPopup> createState() => _LastViewedPopupState();
}

class _LastViewedPopupState extends State<LastViewedPopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPopup(context));
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Olá, bem-vindo de volta!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Deseja continuar do episódio em que parou?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Não',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Sim',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: () async {
                final episodeCache = await widget.cache.get(widget.cacheKey);
                Navigator.of(context).pop();
                if (episodeCache != null) {
                  final season = await HomeController()
                      .selectedFormatedSeason(episodeCache.first);
                  Logger().d('SEASON: $season');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(
                        episode: episodeCache.first,
                        season: season,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

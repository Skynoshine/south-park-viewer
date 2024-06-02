import 'package:flutter/material.dart';
import 'package:myapp/screen/video.dart';
import 'package:myapp/services/episode_entity.dart';

class HomePage extends StatelessWidget {
  final EpisodeEntity data;
  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: data.episodes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(
                  episode: data.episodes[index],
                ),
              ),
            ),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    data.image[index],
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
                    child: Text(data.descriptions[index]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

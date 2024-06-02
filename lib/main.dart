import 'package:flutter/material.dart';
import 'package:myapp/screen/home/home_page.dart';
import 'package:myapp/services/episode_entity.dart';
import 'package:myapp/services/webscrap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<EpisodeEntity> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = Webscrap().southParkStudios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('South Park'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _futureData = Webscrap().southParkStudios();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<EpisodeEntity>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final data = snapshot.data!;

            return HomePage(data: data);
          }
        },
      ),
    );
  }
}

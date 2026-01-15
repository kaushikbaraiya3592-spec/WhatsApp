import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = "Le9zNRqTI8UrTn44sbVmMzfHPTFtWQIlhycSq1jW3cPgIgm9Aw3nwR1l";
  List wallpapers = [];
  bool isLoading = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    fetchWallpapers();
  }

  // 🔹 Fetch Curated Wallpapers
  Future fetchWallpapers() async {
    setState(() => isLoading = true);

    final res = await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=40"),
      headers: {"Authorization": apiKey},
    );

    final data = jsonDecode(res.body);
    setState(() {
      wallpapers = data['photos'];
      isLoading = false;
    });
  }

  // 🔹 Search Wallpapers
  Future searchWallpapers(String text) async {
    if (text.isEmpty) return;

    setState(() => isLoading = true);

    final res = await http.get(
      Uri.parse(
        "https://api.pexels.com/v1/search?query=$text&per_page=40",
      ),
      headers: {"Authorization": apiKey},
    );

    final data = jsonDecode(res.body);
    setState(() {
      wallpapers = data['photos'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallpaper App"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onSubmitted: searchWallpapers,
              decoration: InputDecoration(
                hintText: "Search wallpapers...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: wallpapers.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, i) {
                return CachedNetworkImage(
                  imageUrl: wallpapers[i]['src']['portrait'],
                  fit: BoxFit.cover,
                  placeholder: (c, _) =>
                      Container(color: Colors.grey.shade300),
                );
              },
            ),
    );
  }
}

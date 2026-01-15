import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class FullScreenPage extends StatelessWidget {
  final List wallpapers;
  final int index;

  const FullScreenPage({
    super.key,
    required this.wallpapers,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: PageController(initialPage: index),
        itemCount: wallpapers.length,
        itemBuilder: (context, i) {
          return Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: wallpapers[i]['src']['original'],
                  fit: BoxFit.contain,
                  placeholder: (c, _) =>
                      CircularProgressIndicator(color: Colors.white),
                ),
              ),
              Positioned(
                top: 40,
                left: 15,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

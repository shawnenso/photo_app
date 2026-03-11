import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class GalleryScreen extends StatefulWidget {
  final int albumId;

  const GalleryScreen({super.key, required this.albumId});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List photos = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future loadPhotos() async {
    final result = await ApiService.getAlbumPhotos(widget.albumId);

    setState(() {
      photos = result;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Photos")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),

              itemCount: photos.length,

              itemBuilder: (context, index) {
                return Image.network(photos[index]["image"], fit: BoxFit.cover);
              },
            ),
    );
  }
}

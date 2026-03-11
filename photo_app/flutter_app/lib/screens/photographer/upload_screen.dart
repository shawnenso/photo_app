import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<File> images = [];

  bool uploading = false;

  final picker = ImagePicker();

  Future pickImages() async {
    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        images = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  Future uploadImages() async {
    setState(() {
      uploading = true;
    });

    for (var img in images) {
      await ApiService.uploadPhoto(img, "YOUR_TOKEN");
    }

    setState(() {
      uploading = false;

      images.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Upload complete")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Photos")),

      body: Column(
        children: [
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: pickImages,
            child: const Text("Select Photos"),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),

              itemCount: images.length,

              itemBuilder: (context, index) {
                return Image.file(images[index], fit: BoxFit.cover);
              },
            ),
          ),

          if (images.isNotEmpty)
            ElevatedButton(
              onPressed: uploadImages,
              child: uploading
                  ? const CircularProgressIndicator()
                  : const Text("Upload"),
            ),
        ],
      ),
    );
  }
}

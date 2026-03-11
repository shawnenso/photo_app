import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../../services/api_service.dart';
import '../client/gallery_screen.dart';

class SelfieLoginScreen extends StatefulWidget {
  const SelfieLoginScreen({super.key});

  @override
  State<SelfieLoginScreen> createState() => _SelfieLoginScreenState();
}

class _SelfieLoginScreenState extends State<SelfieLoginScreen> {
  File? _image; // for mobile
  XFile? _webImage; // for web (camera package uses XFile)
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _loading = false;
  String? _errorMessage;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeWebCamera();
    }
  }

  Future<void> _initializeWebCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = "No camera found on this device/browser";
        });
        return;
      }

      // Prefer front camera for selfies
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to open camera: $e";
      });
    }
  }

  Future<void> _pickImageMobile() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;

      setState(() {
        _image = File(picked.path);
      });

      await _loginWithFace();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error taking photo: $e")),
      );
    }
  }

  Future<void> _takeWebSelfie() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final xfile = await _cameraController!.takePicture();
      setState(() {
        _webImage = xfile;
      });

      await _loginWithFace();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to take selfie: $e")),
      );
    }
  }

  Future<void> _loginWithFace() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      dynamic imageToSend;

      if (kIsWeb) {
        if (_webImage == null) return;
        // For web: read bytes and send as multipart or base64
        final bytes = await _webImage!.readAsBytes();
        imageToSend = bytes; // adjust ApiService to handle bytes
      } else {
        if (_image == null) return;
        imageToSend = _image;
      }

      final result = await ApiService.selfieLogin(imageToSend);

      setState(() {
        _loading = false;
      });

      if (result["album_id"] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GalleryScreen(albumId: result["album_id"]),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Face not recognized")),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = "Login failed: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image preview
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            if (kIsWeb && _isCameraInitialized && _cameraController != null)
              SizedBox(
                height: 300,
                width: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CameraPreview(_cameraController!),
                ),
              )
            else if (_image != null)
              Image.file(_image!, height: 200)
            else if (_webImage != null)
              Image.network(_webImage!.path, height: 200) // web preview
            else
              const Icon(Icons.camera_alt, size: 100, color: Colors.grey),

            const SizedBox(height: 20),

            if (_loading) const CircularProgressIndicator(),

            if (!_loading)
              ElevatedButton.icon(
                onPressed: kIsWeb ? _takeWebSelfie : _pickImageMobile,
                icon: const Icon(Icons.camera_alt),
                label: Text(kIsWeb ? "Capture Selfie" : "Take Selfie"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),

            if (kIsWeb && !_isCameraInitialized && !_loading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Please allow camera access in your browser settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
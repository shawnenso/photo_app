import 'package:flutter/material.dart';
import 'screens/login/selfie_login_screen.dart';
import 'screens/photographer/upload_screen.dart';

void main() {
  runApp(const PhotoAIApp());
}

class PhotoAIApp extends StatelessWidget {
  const PhotoAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Photo AI",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SelfieLoginScreen(),
    );
  }
}

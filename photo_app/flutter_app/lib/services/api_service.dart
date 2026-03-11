import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../config/api_config.dart';

class ApiService {
  static Future<dynamic> selfieLogin(File image) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/recognition/selfie-login/");

    var request = http.MultipartRequest("POST", url);

    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    return jsonDecode(responseData);
  }

  static Future<dynamic> getAlbumPhotos(int albumId) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/albums/$albumId/photos/");

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  static Future uploadPhoto(File image, String token) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/photos/upload/");

    var request = http.MultipartRequest("POST", url);

    request.headers["Authorization"] = "Bearer $token";

    request.files.add(await http.MultipartFile.fromPath("image", image.path));

    var response = await request.send();

    return response.statusCode;
  }
}

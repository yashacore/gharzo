import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/add_property_type/upload_photo_model.dart';
import 'package:gharzo_project/screens/add_properties/location/location_view.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class PhotoUploadProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  final List<File> selectedImages = [];
  final List<Uint8List> webImages = [];

  // ================= ADD IMAGES =================
  void addImagesFromPicker(List<File> files) {
    selectedImages.addAll(files);
    notifyListeners();
  }

  void addWebImages(List<Uint8List> images) {
    webImages.addAll(images);
    notifyListeners();
  }

  // ================= REMOVE =================
  void removeImage(int index) {
    if (kIsWeb) {
      webImages.removeAt(index);
    } else {
      selectedImages.removeAt(index);
    }
    notifyListeners();
  }

  // ================= COUNT =================
  int get totalImages => kIsWeb ? webImages.length : selectedImages.length;

  // ================= VALIDATION =================
  bool validate() {
    if (totalImages == 0) {
      error = "Please upload at least one image";
      notifyListeners();
      return false;
    }
    return true;
  }

  // ================= UPLOAD =================
  Future<PhotoUploadResponseModel?> upload(String propertyId) async {
    if (!validate()) return null;

    loading = true;
    error = null;
    notifyListeners();

    try {
      final token = await PrefService.getToken();
      if (token == null || token.isEmpty) throw Exception("User not logged in");

      final uri = Uri.parse(
          'https://api.gharzoreality.com/api/v2/properties/$propertyId/upload-photos');

      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // ========= WEB =========
      if (kIsWeb) {
        for (int i = 0; i < webImages.length; i++) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'images',
              webImages[i],
              filename: 'web_image_$i.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      } else {
        // ========= MOBILE =========
        for (var file in selectedImages) {
          final ext = extension(file.path).toLowerCase().replaceAll('.', '');
          if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
            error = "Only jpg, jpeg, png, webp files allowed";
            loading = false;
            notifyListeners();
            return null;
          }

          request.files.add(await http.MultipartFile.fromPath(
            'images',
            file.path,
            filename: basename(file.path),
            contentType: MediaType('image', ext),
          ));
        }
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      debugPrint("📤 Upload Status: ${response.statusCode}");
      debugPrint("📤 Upload Response: $respStr");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respJson = jsonDecode(respStr);
        loading = false;
        notifyListeners();
        return PhotoUploadResponseModel.fromJson(respJson);
      } else {
        error = "Upload failed (${response.statusCode})";
        loading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      error = "Upload failed";
      loading = false;
      notifyListeners();
      return null;
    }
  }

  void clickOnBtn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocationView(propertyId: '')),
    );
  }
}

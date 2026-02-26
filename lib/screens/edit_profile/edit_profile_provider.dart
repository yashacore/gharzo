import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/model/user_model/user_model.dart';
import 'package:gharzo_project/screens/profile/profile_provider.dart';
import 'package:gharzo_project/screens/profile/profile_view.dart';

class EditProfileProvider extends ChangeNotifier {
  // -------------------------------
  // CONTROLLERS
  // -------------------------------
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  /// Existing image URL (from backend)
  String profileImage = '';

  /// Picked image file
  File? profileImageFile;

  bool isBtnLoading = false;

  // -------------------------------
  // FETCH PROFILE FROM PREF
  // -------------------------------
  Future<void> fetchProfile() async {
    isBtnLoading = true;
    notifyListeners();

    try {
      final user = await PrefService.getUser();
      debugPrint("👤 USER FROM PREF => $user");

      if (user != null) {
        userNameController.text = user['name'] ?? '';
        phoneNumberController.text = user['phone'] ?? '';
        emailController.text = user['email'] ?? '';

        final address = user['address'];
        if (address != null && address is Map) {
          cityController.text = address['city'] ?? '';
          stateController.text = address['state'] ?? '';
          pincodeController.text = address['pincode'] ?? '';
        }

        profileImage = user['profileImage']?['url'] ?? '';
      }
    } catch (e) {
      debugPrint("❌ Fetch profile error: $e");
    } finally {
      isBtnLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // PICK IMAGE
  // -------------------------------
  Future<void> pickProfileImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 85, // forces JPEG
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image == null) return;

    profileImageFile = File(image.path);
    notifyListeners();
  }

  // -------------------------------
  // UPDATE PROFILE
  // -------------------------------
  Future<void> updateProfile() async {
    isBtnLoading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Session expired. Please login again.");
      }

      final uri = Uri.parse(
        "https://api.gharzoreality.com/api/auth/update_profile",
      );

      final request = http.MultipartRequest("PUT", uri);
      request.headers['Authorization'] = "Bearer $token";

      /// 📄 FIELDS (CLEAN & EXPLICIT)
      request.fields.addAll({
        'name': userNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneNumberController.text.trim(),
        'address[city]': cityController.text.trim(),
        'address[state]': stateController.text.trim(),
        'address[pincode]': pincodeController.text.trim(),
      });

      /// 🖼️ PROFILE IMAGE
      if (profileImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            profileImageFile!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      debugPrint("📤 Sending update profile request");

      final streamedResponse = await request.send();
      final responseBody =
      await streamedResponse.stream.bytesToString();

      debugPrint("📥 Status => ${streamedResponse.statusCode}");
      debugPrint("📥 Body => $responseBody");

      final decoded = jsonDecode(responseBody);

      if (streamedResponse.statusCode != 200 ||
          decoded['success'] != true) {
        throw Exception(decoded['message'] ?? "Profile update failed");
      }

      /// ✅ SAVE UPDATED USER
      final updatedUser = UserModel.fromJson(decoded['data']);
      await PrefService.saveUser(updatedUser);

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 600));

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProfileProvider(),
            child: BottomBarView(),
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ UPDATE PROFILE ERROR => $e");
      ScaffoldMessenger.of(
        navigatorKey.currentContext!,
      ).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      isBtnLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // REMOVE IMAGE
  // -------------------------------
  void removeProfileImage() {
    profileImage = '';
    profileImageFile = null;
    notifyListeners();
  }
}
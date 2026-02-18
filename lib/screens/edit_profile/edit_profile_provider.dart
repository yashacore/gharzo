import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/model/add_property_type/update_profile_request_model.dart';
import 'package:gharzo_project/model/user_model/user_model.dart';
import 'package:gharzo_project/screens/profile/profile_provider.dart';
import 'package:gharzo_project/screens/profile/profile_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileProvider extends ChangeNotifier {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  String profileImage = '';
  bool isBtnLoading = false;



  String userName = '';
  String phone = '';
  String email = '';
  String address = '';

  /// Fetch user data from PrefService
  Future<void> fetchProfile() async {
    isBtnLoading = true;
    notifyListeners();

    try {
      final user = await PrefService.getUser();
      debugPrint("USER FROM PREF ::: $user");

      if (user != null) {
        userName = user['name'] ?? '';
        phone = user['phone'] ?? '';
        email = user['email'] ?? '';
        address = user['address'] ?? '';
        profileImage = user['image'] ?? '';

        userNameController.text = userName;
        phoneNumberController.text = phone;
        emailController.text = email;
        addressController.text = address;
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isBtnLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image == null) return;

    profileImage = image.path;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    isBtnLoading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();
      debugPrint("🔑 TOKEN FROM PREF: $token");

      if (token == null || token.isEmpty) {
        throw Exception("Session expired. Please login again.");
      }

      Address? addressObj;
      if (addressController.text.isNotEmpty) {
        final parts = addressController.text.split(',');
        addressObj = Address(
          city: parts.isNotEmpty ? parts[0].trim() : null,
          state: parts.length > 1 ? parts[1].trim() : null,
          pincode: parts.length > 2 ? parts[2].trim() : null,
        );
      }

      final response = await AuthService.updateProfile(
        token: token,
        name: userNameController.text.trim(),
        phone: phoneNumberController.text.trim(),
        address: addressObj,
      );
      if (!response.success) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (response.data == null) {
        throw Exception("User data missing from response");
      }

      // ✅ SUCCESS
      final updatedUser = response.data as UserModel;
      await PrefService.saveUser(updatedUser);

      debugPrint("✅ PROFILE UPDATED");
      debugPrint(updatedUser.toJson().toString());

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProfileProvider(),
            child: ProfilePage(),
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ UPDATE PROFILE ERROR: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      isBtnLoading = false;
      notifyListeners();
    }
  }



  void removeProfileImage() {
    profileImage = '';
    notifyListeners();
  }
}

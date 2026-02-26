
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar_provider.dart';
import 'package:gharzo_project/screens/edit_profile/edit_profile_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EditProfileProvider>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (context, value, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          body: Column(
            children: [
              /// 🔝 HEADER
              Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppThemeColors().backgroundLeft,
                      AppThemeColors().backgroundRight,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        navigatorKey.currentState?.pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => BottomBarProvider(),
                              child: BottomBarView(),
                            ),
                          ),
                        );
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              /// 🧾 BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// 🖼 PROFILE IMAGE CARD
                      _card(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: value.profileImageFile != null
                                      ? FileImage(value.profileImageFile!)
                                      : (value.profileImage.isNotEmpty
                                      ? NetworkImage(value.profileImage)
                                      : null) as ImageProvider?,
                                  child: value.profileImage.isEmpty &&
                                      value.profileImageFile == null
                                      ? const Icon(Icons.person,
                                      size: 50, color: Colors.white)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () =>
                                        _showImagePicker(context, value),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tap to change profile photo",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 👤 PERSONAL DETAILS
                      _sectionCard(
                        title: "Personal Details",
                        child: Column(
                          children: [
                            _input(
                              label: "Full Name",
                              controller: value.userNameController,
                            ),
                            _input(
                              label: "Phone Number",
                              controller: value.phoneNumberController,
                              keyboard: TextInputType.phone,
                            ),
                            _input(
                              label: "Email",
                              controller: value.emailController,
                              keyboard: TextInputType.emailAddress,

                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🏠 ADDRESS DETAILS (SEPARATE FIELDS)
                      _sectionCard(
                        title: "Address",
                        child: Column(
                          children: [
                            _input(
                              label: "City",
                              controller: value.cityController,
                            ),
                            _input(
                              label: "State",
                              controller: value.stateController,
                            ),
                            _input(
                              label: "Pincode",
                              controller: value.pincodeController,
                              keyboard: TextInputType.number,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// 💾 SAVE BUTTON
                      PrimaryButton(title: "Save Changes",
                          onPressed: value.isBtnLoading
                              ? null
                              : () => value.updateProfile(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// -----------------------
  /// IMAGE PICKER
  /// -----------------------
  void _showImagePicker(
      BuildContext context, EditProfileProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickProfileImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickProfileImage(ImageSource.gallery);
                },
              ),
              if (provider.profileImage.isNotEmpty ||
                  provider.profileImageFile != null)
                ListTile(
                  leading:
                  const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Remove"),
                  onTap: () {
                    Navigator.pop(context);
                    provider.removeProfileImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// -----------------------
  /// UI HELPERS
  /// -----------------------
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
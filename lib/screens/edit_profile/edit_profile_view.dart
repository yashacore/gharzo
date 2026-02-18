import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
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
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppThemeColors().backgroundLeft,
                      AppThemeColors().backgroundRight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
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
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 26,
                        padding: EdgeInsets.zero,
                        constraints:  BoxConstraints(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Center(
                          child: Text(
                              "Edit Profile",
                            style: Theme.of(context).textTheme.displayLarge,
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child:SingleChildScrollView(
                      child: Form(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: CommonWidget.profileImagePicker(
                                  imagePath: value.profileImage,
                                  onTapCamera: () {
                                    CommonWidget.showImage(
                                      context: context,
                                      onCamera: () =>
                                          value.pickProfileImage(ImageSource.camera),
                                      onGallery: () =>
                                          value.pickProfileImage(ImageSource.gallery),
                                      onRemove: value.removeProfileImage,
                                      showRemove: value.profileImage.isNotEmpty,
                                    );
                                  },
                                ),

                              ),

                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 6,
                                children:[
                                  Text(
                                    "Personal Details",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text("Full Name"),
                                  fullNameTextFormField(value),
                                  SizedBox(height: 8,),
                                  Text("Phone Number"),
                                  mobileTextFormField(value),
                                  SizedBox(height: 8,),
                                  Text("Email"),
                                  emailTextFormField(value),
                                  SizedBox(height: 8,),
                                  Text("Address"),
                                  addressTextFormField(value),
                                ],
                              ),
                              SizedBox(height: 16,),
                              CommonWidget.commonElevatedBtn(
                                btnText: value.isBtnLoading ? "Change..." : "Save Change",
                                isLoading: value.isBtnLoading,
                                onPressed: value.isBtnLoading
                                    ? null
                                    : () async => await value.updateProfile(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        );
      },
    );
  }

  Widget fullNameTextFormField(EditProfileProvider value) =>
      CommonWidget.commonTextFormField(
        hint: value.userName.isNotEmpty ? value.userName : "Full Name",
        controller: value.userNameController,
        keyboardType: TextInputType.text,
      );

  Widget mobileTextFormField(EditProfileProvider value) =>
      CommonWidget.commonTextFormField(
        hint: value.phone.isNotEmpty ? value.phone : "Phone Number",
        controller: value.phoneNumberController,
        keyboardType: TextInputType.phone,
      );

  Widget emailTextFormField(EditProfileProvider value) =>
      CommonWidget.commonTextFormField(
        hint: "Enter Email",
        controller: value.emailController,
        keyboardType: TextInputType.emailAddress,
      );

  Widget addressTextFormField(EditProfileProvider value) =>
      CommonWidget.commonTextFormField(
        hint: "Enter Address",
        controller: value.addressController,
        keyboardType: TextInputType.text,
      );

}

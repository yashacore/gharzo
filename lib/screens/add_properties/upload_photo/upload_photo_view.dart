import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';
import 'upload_photo_provider.dart';
import '../contact_information/contact_info_view.dart';

class UploadPhotoView extends StatelessWidget {
  final String propertyId;

  const UploadPhotoView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhotoUploadProvider(),
      child: Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.uploadPhoto,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<PhotoUploadProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImages(provider),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.cloud_upload, size: 40),
                                SizedBox(height: 8),
                                Text("Tap to upload images"),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🖼 IMAGE GRID
                        if (provider.totalImages > 0) ...[
                          Text(
                            "${provider.totalImages} Photos Selected",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: provider.totalImages,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb
                                        ? Image.memory(
                                      provider.webImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                        : Image.file(
                                      provider.selectedImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () =>
                                          provider.removeImage(index),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.black54,
                                        child: Icon(Icons.close,
                                            size: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                /// ⬇ BUTTON
                PrimaryButton(title: "Upload",
                  onPressed: provider.loading || provider.totalImages == 0
                      ? null
                      : () async {
                    final response = await provider.upload(propertyId);
                    if (response != null && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactInfoView(
                            propertyId: propertyId,
                          ),
                        ),
                      );
                    } else if (response == null) {
                      // Optional: show error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error ?? "Upload failed")),
                      );
                    }
                  },                )

              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImages(PhotoUploadProvider provider) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result == null) return;

    if (kIsWeb) {
      List<Uint8List> images =
      result.files.map((e) => e.bytes!).toList();
      provider.addWebImages(images);
    } else {
      List<File> images =
      result.files.map((e) => File(e.path!)).toList();
      provider.addImagesFromPicker(images);
    }
  }
}

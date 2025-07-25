
import 'dart:convert';
import 'dart:io';

import 'package:admin_pannel/services/assets_manger.dart';
import 'package:admin_pannel/widget/subtitle_text.dart';
import 'package:admin_pannel/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyAppMethods {

   

static Future<String?> uploadImageToCloud(File imageFile) async {
  const uploadPreset = 'food-fyp';
  final uri = Uri.parse('https://api.cloudinary.com/v1_1/dcuxllwmz/image/upload');

  print('Uploading image at path: ${imageFile.path}');
  print('File exists? ${await imageFile.exists()}');

  if (!await imageFile.exists()) {
    print('Image file not found at ${imageFile.path}');
    return null;
  }

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  try {
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    print('Cloudinary raw response: $respStr');

    if (response.statusCode == 200) {
      final data = json.decode(respStr);
      return data['secure_url'];
    } else {
      print('Cloudinary upload failed with status ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Upload exception: $e');
    return null;
  }
}



 static Future<void> showErrorORWarningDialog({
    required BuildContext context,
    required String subtitle,
    required Function fct,
    bool isError = true,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AssetsManager.warning,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SubtitleText(
                  label: subtitle,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isError,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const SubtitleText(
                            label: "Cancel", color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        fct();
                        Navigator.pop(context);
                      },
                      child: const SubtitleText(
                          label: "OK", color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitleText(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text(
                    "Camera",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text(
                    "Gallery",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text(
                    "Remove",
                  ),
                ),
              ],
            )),
          );
        });
  }

}
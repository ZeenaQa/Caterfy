import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> pickAndCropImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked == null) return null;

  final CroppedFile? cropped = await ImageCropper().cropImage(
    sourcePath: picked.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      ),
      IOSUiSettings(title: 'Crop Image'),
    ],
  );

  if (cropped == null) return null;

  return File(cropped.path);
}

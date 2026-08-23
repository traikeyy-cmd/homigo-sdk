import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

enum HomiGoImageSource { camera, gallery }

class HomiGoPickedImage {
  final String name;
  final String path;
  final String? mimeType;

  final int? width;
  final int? height;

  const HomiGoPickedImage({
    required this.name,
    required this.path,
    this.mimeType,
    this.width,
    this.height,
  });

  Future<Uint8List> readBytes() async {
    return XFile(path).readAsBytes();
  }
}

class HomiGoImagePicker {
  final ImagePicker _picker;

  HomiGoImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  Future<HomiGoPickedImage?> pickImage({
    HomiGoImageSource source = HomiGoImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final file = await _picker.pickImage(
      source: source == HomiGoImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );

    if (file == null) {
      return null;
    }

    return HomiGoPickedImage(
      name: file.name,
      path: file.path,
      mimeType: file.mimeType,
    );
  }

  Future<List<HomiGoPickedImage>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final files = await _picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );

    return files
        .map(
          (file) => HomiGoPickedImage(
            name: file.name,
            path: file.path,
            mimeType: file.mimeType,
          ),
        )
        .toList();
  }
}

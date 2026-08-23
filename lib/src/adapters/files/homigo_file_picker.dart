import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class HomiGoPickedFile {
  final String name;
  final String? path;
  final int size;
  final String? extension;
  final Uint8List? bytes;

  const HomiGoPickedFile({
    required this.name,
    required this.size,
    this.path,
    this.extension,
    this.bytes,
  });
}

class HomiGoFilePicker {
  const HomiGoFilePicker();

  Future<HomiGoPickedFile?> pickFile({
    List<String>? allowedExtensions,
    bool withData = false,
  }) async {
    final file = await FilePicker.pickFile(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (file == null) {
      return null;
    }

    return _map(file, withData: withData);
  }

  Future<List<HomiGoPickedFile>> pickFiles({
    List<String>? allowedExtensions,
    bool withData = false,
  }) async {
    final files = await FilePicker.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) {
      return const [];
    }

    final results = <HomiGoPickedFile>[];

    for (final file in files) {
      results.add(await _map(file, withData: withData));
    }

    return results;
  }

  Future<HomiGoPickedFile> _map(
    PlatformFile file, {
    required bool withData,
  }) async {
    final size = await file.length();

    Uint8List? bytes;

    if (withData) {
      bytes = await file.readAsBytes();
    }

    return HomiGoPickedFile(
      name: file.name,
      path: file.path,
      size: size,
      extension: _extensionFromName(file.name),
      bytes: bytes,
    );
  }

  String? _extensionFromName(String name) {
    final dotIndex = name.lastIndexOf('.');

    if (dotIndex <= 0 || dotIndex == name.length - 1) {
      return null;
    }

    return name.substring(dotIndex + 1).toLowerCase();
  }
}

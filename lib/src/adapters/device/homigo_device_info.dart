import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class HomiGoDeviceData {
  final String platform;
  final String? model;
  final String? manufacturer;
  final String? systemVersion;
  final bool isPhysicalDevice;

  final Map<String, Object?> raw;

  const HomiGoDeviceData({
    required this.platform,
    required this.isPhysicalDevice,
    this.model,
    this.manufacturer,
    this.systemVersion,
    this.raw = const {},
  });
}

class HomiGoDeviceInfo {
  final DeviceInfoPlugin _plugin;

  HomiGoDeviceInfo({DeviceInfoPlugin? plugin})
    : _plugin = plugin ?? DeviceInfoPlugin();

  Future<HomiGoDeviceData> load() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;

      return HomiGoDeviceData(
        platform: 'android',
        model: info.model,
        manufacturer: info.manufacturer,
        systemVersion: info.version.release,
        isPhysicalDevice: info.isPhysicalDevice,
        raw: {
          'sdkInt': info.version.sdkInt,
          'brand': info.brand,
          'device': info.device,
          'product': info.product,
        },
      );
    }

    if (Platform.isIOS) {
      final info = await _plugin.iosInfo;

      return HomiGoDeviceData(
        platform: 'ios',
        model: info.utsname.machine,
        manufacturer: 'Apple',
        systemVersion: info.systemVersion,
        isPhysicalDevice: info.isPhysicalDevice,
        raw: {
          'name': info.name,
          'systemName': info.systemName,
          'model': info.model,
        },
      );
    }

    return const HomiGoDeviceData(platform: 'unknown', isPhysicalDevice: false);
  }
}

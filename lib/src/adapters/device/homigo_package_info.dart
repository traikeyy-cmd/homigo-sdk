import 'package:package_info_plus/package_info_plus.dart';

class HomiGoPackageData {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  const HomiGoPackageData({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
}

class HomiGoPackageInfo {
  const HomiGoPackageInfo();

  Future<HomiGoPackageData> load() async {
    final info = await PackageInfo.fromPlatform();

    return HomiGoPackageData(
      appName: info.appName,
      packageName: info.packageName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }
}

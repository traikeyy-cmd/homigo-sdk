import 'package:permission_handler/permission_handler.dart' as ph;

import '../../core/permissions/homigo_permissions.dart';

class HomiGoPermissionHandlerAdapter implements HomiGoPermissionsAdapter {
  const HomiGoPermissionHandlerAdapter();

  @override
  Future<HomiGoPermissionStatus> check(HomiGoPermission permission) async {
    final status = await _permission(permission).status;

    return _mapStatus(status);
  }

  @override
  Future<HomiGoPermissionStatus> request(HomiGoPermission permission) async {
    final status = await _permission(permission).request();

    return _mapStatus(status);
  }

  @override
  Future<Map<HomiGoPermission, HomiGoPermissionStatus>> requestMany(
    Iterable<HomiGoPermission> permissions,
  ) async {
    final result = <HomiGoPermission, HomiGoPermissionStatus>{};

    for (final permission in permissions) {
      final nativeStatus = await _permission(permission).request();

      result[permission] = _mapStatus(nativeStatus);
    }

    return result;
  }

  @override
  Future<bool> openAppSettings() {
    return ph.openAppSettings();
  }

  ph.Permission _permission(HomiGoPermission permission) {
    return switch (permission) {
      HomiGoPermission.camera => ph.Permission.camera,

      HomiGoPermission.microphone => ph.Permission.microphone,

      HomiGoPermission.photos => ph.Permission.photos,

      HomiGoPermission.storage => ph.Permission.storage,

      HomiGoPermission.location => ph.Permission.locationWhenInUse,

      HomiGoPermission.notifications => ph.Permission.notification,

      HomiGoPermission.contacts => ph.Permission.contacts,
    };
  }

  HomiGoPermissionStatus _mapStatus(ph.PermissionStatus status) {
    if (status.isGranted) {
      return HomiGoPermissionStatus.granted;
    }

    if (status.isPermanentlyDenied) {
      return HomiGoPermissionStatus.permanentlyDenied;
    }

    if (status.isRestricted) {
      return HomiGoPermissionStatus.restricted;
    }

    if (status.isLimited) {
      return HomiGoPermissionStatus.limited;
    }

    if (status.isDenied) {
      return HomiGoPermissionStatus.denied;
    }

    return HomiGoPermissionStatus.unknown;
  }
}

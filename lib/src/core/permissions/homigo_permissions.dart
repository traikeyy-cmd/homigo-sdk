enum HomiGoPermission {
  camera,
  microphone,
  photos,
  storage,
  location,
  notifications,
  contacts,
}

enum HomiGoPermissionStatus {
  granted,
  denied,
  restricted,
  permanentlyDenied,
  limited,
  unknown,
}

abstract interface class HomiGoPermissionsAdapter {
  Future<HomiGoPermissionStatus> check(HomiGoPermission permission);

  Future<HomiGoPermissionStatus> request(HomiGoPermission permission);

  Future<Map<HomiGoPermission, HomiGoPermissionStatus>> requestMany(
    Iterable<HomiGoPermission> permissions,
  );

  Future<bool> openAppSettings();
}

class HomiGoPermissions {
  final HomiGoPermissionsAdapter adapter;

  const HomiGoPermissions({required this.adapter});

  Future<HomiGoPermissionStatus> check(HomiGoPermission permission) {
    return adapter.check(permission);
  }

  Future<HomiGoPermissionStatus> request(HomiGoPermission permission) {
    return adapter.request(permission);
  }

  Future<bool> ensure(HomiGoPermission permission) async {
    final current = await check(permission);

    if (current == HomiGoPermissionStatus.granted) {
      return true;
    }

    final result = await request(permission);

    return result == HomiGoPermissionStatus.granted;
  }

  Future<Map<HomiGoPermission, HomiGoPermissionStatus>> requestMany(
    Iterable<HomiGoPermission> permissions,
  ) {
    return adapter.requestMany(permissions);
  }

  Future<bool> openAppSettings() {
    return adapter.openAppSettings();
  }
}

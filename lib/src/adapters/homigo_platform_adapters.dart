import '../core/config/homigo_services.dart';
import '../core/connectivity/homigo_connectivity.dart';
import '../core/permissions/homigo_permissions.dart';
import '../core/session/homigo_session.dart';
import 'connectivity/homigo_connectivity_plus_adapter.dart';
import 'network/homigo_http_transport.dart';
import 'permissions/homigo_permission_handler_adapter.dart';
import 'storage/homigo_flutter_secure_storage.dart';
import 'storage/homigo_shared_preferences_storage.dart';

class HomiGoPlatformAdapters {
  final HomiGoSharedPreferencesStorage storage;
  final HomiGoFlutterSecureStorage secureStorage;

  final HomiGoConnectivity connectivity;
  final HomiGoPermissions permissions;

  final HomiGoHttpTransport httpTransport;

  HomiGoPlatformAdapters._({
    required this.storage,
    required this.secureStorage,
    required this.connectivity,
    required this.permissions,
    required this.httpTransport,
  });

  static Future<HomiGoPlatformAdapters> initialize({
    bool registerServices = true,
  }) async {
    final storage = HomiGoSharedPreferencesStorage();

    const secureStorage = HomiGoFlutterSecureStorage();

    final connectivity = HomiGoConnectivity(
      adapter: HomiGoConnectivityPlusAdapter(),
    );

    const permissions = HomiGoPermissions(
      adapter: HomiGoPermissionHandlerAdapter(),
    );

    final httpTransport = HomiGoHttpTransport();

    if (registerServices) {
      HomiGoServices.storage = storage;
      HomiGoServices.secureStorage = secureStorage;

      HomiGoServices.session = HomiGoSession(storage: secureStorage);

      HomiGoServices.connectivity = connectivity;
      HomiGoServices.permissions = permissions;
    }

    return HomiGoPlatformAdapters._(
      storage: storage,
      secureStorage: secureStorage,
      connectivity: connectivity,
      permissions: permissions,
      httpTransport: httpTransport,
    );
  }
}

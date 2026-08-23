import '../connectivity/homigo_connectivity.dart';
import '../network/homigo_network_client.dart';
import '../permissions/homigo_permissions.dart';
import '../session/homigo_session.dart';
import '../storage/homigo_storage.dart';

abstract final class HomiGoServices {
  static HomiGoStorage? storage;

  static HomiGoSecureStorage? secureStorage;

  static HomiGoSession? session;

  static HomiGoNetworkClient? network;

  static HomiGoConnectivity? connectivity;

  static HomiGoPermissions? permissions;

  static void reset() {
    storage = null;
    secureStorage = null;
    session = null;
    network = null;
    connectivity = null;
    permissions = null;
  }
}

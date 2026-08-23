import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/connectivity/homigo_connectivity.dart';

class HomiGoConnectivityPlusAdapter implements HomiGoConnectivityAdapter {
  final Connectivity _connectivity;

  HomiGoConnectivityPlusAdapter({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<HomiGoConnectivityStatus> check() async {
    final results = await _connectivity.checkConnectivity();

    return _map(results);
  }

  @override
  Stream<HomiGoConnectivityStatus> get changes {
    return _connectivity.onConnectivityChanged.map(_map);
  }

  HomiGoConnectivityStatus _map(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return HomiGoConnectivityStatus.unknown;
    }

    if (results.every((result) => result == ConnectivityResult.none)) {
      return HomiGoConnectivityStatus.offline;
    }

    return HomiGoConnectivityStatus.online;
  }
}

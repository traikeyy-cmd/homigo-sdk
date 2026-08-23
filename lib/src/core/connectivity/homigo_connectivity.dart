enum HomiGoConnectivityStatus { online, offline, unknown }

abstract interface class HomiGoConnectivityAdapter {
  Future<HomiGoConnectivityStatus> check();

  Stream<HomiGoConnectivityStatus> get changes;
}

class HomiGoConnectivity {
  final HomiGoConnectivityAdapter adapter;

  const HomiGoConnectivity({required this.adapter});

  Future<HomiGoConnectivityStatus> check() {
    return adapter.check();
  }

  Stream<HomiGoConnectivityStatus> get changes => adapter.changes;

  Future<bool> get isOnline async {
    return await check() == HomiGoConnectivityStatus.online;
  }
}

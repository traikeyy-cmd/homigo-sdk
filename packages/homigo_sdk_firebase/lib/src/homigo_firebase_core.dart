import 'package:firebase_core/firebase_core.dart';

class HomiGoFirebaseCore {
  const HomiGoFirebaseCore();

  Future<FirebaseApp> initialize({
    FirebaseOptions? options,
    String? name,
  }) async {
    if (name != null) {
      return Firebase.initializeApp(name: name, options: options);
    }

    if (Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }

    return Firebase.initializeApp(options: options);
  }

  FirebaseApp get defaultApp => Firebase.app();

  List<FirebaseApp> get apps => Firebase.apps;
}

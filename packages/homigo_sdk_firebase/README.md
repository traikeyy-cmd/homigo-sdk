# HomiGo SDK Firebase

Optional Firebase integrations for HomiGo SDK.

This package is intentionally separated from the Core SDK so applications that do not use Firebase do not inherit Firebase dependencies.

## Version

Current release: **1.0.0**

## Features

- Firebase Core
- Firebase Authentication
- Firebase Cloud Messaging
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config
- Unified Firebase service registry
- FlutterFire generated options support
- Configurable Crashlytics initialization
- Configurable Remote Config initialization

## Installation

Add the Firebase companion package to your Flutter project:

```bash
flutter pub add homigo_sdk_firebase
```

Or add the Core SDK and Firebase companion package manually:

```yaml
dependencies:
  homigo_sdk: ^1.0.1
  homigo_sdk_firebase: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Initialization

Import the package:

```dart
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';
```

Initialize Firebase:

```dart
await HomiGoFirebase.initialize();
```

## FlutterFire Options

Applications configured with FlutterFire can pass generated platform-specific options:

```dart
await HomiGoFirebase.initialize(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

The host application is responsible for importing its generated `firebase_options.dart` file.

## Configuration

Firebase initialization can be customized with `HomiGoFirebaseConfig`:

```dart
await HomiGoFirebase.initialize(
  options: DefaultFirebaseOptions.currentPlatform,
  config: const HomiGoFirebaseConfig(
    enableCrashlytics: true,
    initializeRemoteConfig: true,
    remoteConfigFetchTimeout: Duration(seconds: 10),
    remoteConfigMinimumFetchInterval: Duration(hours: 1),
    remoteConfigDefaults: {
      'maintenance_mode': false,
    },
  ),
);
```

## Available Services

Firebase services are available through `HomiGoFirebaseServices`:

```dart
final auth = HomiGoFirebaseServices.auth;
final messaging = HomiGoFirebaseServices.messaging;
final analytics = HomiGoFirebaseServices.analytics;
final crashlytics = HomiGoFirebaseServices.crashlytics;
final remoteConfig = HomiGoFirebaseServices.remoteConfig;
```

## Unified HomiGo Bootstrap

Firebase can be initialized after the HomiGo Core SDK through the bootstrap hook:

```dart
import 'package:homigo_sdk/homigo_sdk.dart';
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';

await HomiGoBootstrap.initialize(
  config: HomiGoBootstrapConfig(
    sdkConfig: const HomiGoConfig(
      appName: 'My HomiGo App',
    ),
    afterCoreInitialize: () async {
      await HomiGoFirebase.initialize(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    },
  ),
);
```

## Host Application Configuration

Firebase configuration belongs to the host application.

Depending on the platform and setup, the host application may require:

- `google-services.json`
- `GoogleService-Info.plist`
- Generated `firebase_options.dart`
- Android Google Services Gradle configuration
- Apple platform Firebase configuration
- Firebase services enabled in the Firebase Console

HomiGo SDK Firebase does not embed application-specific Firebase credentials.

## Core SDK

This package depends on HomiGo Core SDK.

```yaml
dependencies:
  homigo_sdk: ^1.0.1
```

Core SDK repository:

[https://github.com/traikeyy-cmd/homigo-sdk](https://github.com/traikeyy-cmd/homigo-sdk)

## Development

Get dependencies:

```bash
flutter pub get
```

Analyze:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Test the package publication:

```bash
dart pub publish --dry-run
```

## SDK Requirements

- Dart `>=3.11.0 <4.0.0`
- Flutter compatible with Dart 3.11 or newer
- A Firebase project configured by the host application

## Issues

Report bugs and request features through the [GitHub issue tracker](https://github.com/traikeyy-cmd/homigo-sdk/issues).

## License

HomiGo SDK Firebase is available under the BSD 3-Clause License.

Copyright © 2026 HomiGo.
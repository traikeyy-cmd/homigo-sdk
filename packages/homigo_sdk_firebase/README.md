# HomiGo SDK Firebase

Optional Firebase integrations for HomiGo SDK.

This package is intentionally separated from the Core SDK so applications
that do not use Firebase do not inherit Firebase dependencies.

## Version

Current release: **1.0.0**

## Features

- Firebase Core
- Firebase Authentication
- Firebase Cloud Messaging
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config

## Installation

```yaml
dependencies:
  homigo_sdk_firebase:
    git:
      url: https://github.com/traikeyy-cmd/homigo-sdk.git
      ref: v1.0.0
      path: packages/homigo_sdk_firebase
```

## Initialization

```dart
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';

await HomiGoFirebase.initialize();
```

With FlutterFire generated options:

```dart
await HomiGoFirebase.initialize(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Host Application Configuration

Firebase configuration is owned by the host application.

Depending on the setup, the host application may require:

- `google-services.json`
- `GoogleService-Info.plist`
- Generated `firebase_options.dart`

HomiGo SDK Firebase does not embed application-specific Firebase credentials.

## Core SDK

The Firebase package is designed to work alongside the main HomiGo SDK.

Core SDK repository:

```text
https://github.com/traikeyy-cmd/homigo-sdk
```

## License

HomiGo SDK Firebase is proprietary software.

Copyright © 2026 HomiGo. All rights reserved.

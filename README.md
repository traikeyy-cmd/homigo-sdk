# HomiGo SDK

**HomiGo SDK** is a reusable Flutter foundation for HomiGo applications.

It provides a shared design system, platform adapters, core application services, networking infrastructure, production hardening, and optional Firebase integrations.

## Version

Current release: **1.0.0**

## Features

### Design System

- Liquid / Water Glass visual system
- Material 3
- Light, dark, and system themes
- Central brand configuration
- Typography, spacing, radius, and color tokens
- Edge-to-edge system UI
- Safe area handling
- Keyboard inset handling

### UI Components

HomiGo SDK includes reusable components for:

- Buttons
- Text fields
- Dropdowns
- Searchable dropdowns
- Number and phone inputs
- Checkboxes
- Radio controls
- Switches
- Segmented controls
- Tabs
- Cards
- List tiles
- Expansion tiles
- Chips
- Badges
- Avatars
- App bars
- Navigation bars
- Drawers
- Bottom sheets
- Dialogs
- Snackbars
- Menus
- Tooltips
- Sliders
- Range sliders
- Progress indicators
- Date and time pickers
- Steppers
- Skeleton loading
- Loading, empty, and error states

### Core Services

- Central SDK configuration
- Service registry
- Logging
- Environment configuration
- Validation utilities
- Formatting utilities
- Localization foundation
- Storage abstraction
- Secure storage abstraction
- Session management
- HTTP networking
- Connectivity abstraction
- Permission abstraction

### Platform Adapters

- SharedPreferences
- Flutter Secure Storage
- HTTP transport
- Connectivity Plus
- Permission Handler
- File Picker
- Image Picker
- Device information
- Package information

### Production Infrastructure

- Unified application bootstrap
- `HomiGoResult<T>`
- Central error mapping
- Retry policies
- Exponential backoff
- Timeout policies
- Cancellation tokens
- Network interceptors
- Offline request protection
- Authentication token refresh coordination
- Application lifecycle monitoring
- Diagnostics
- Health checks

## Installation

HomiGo SDK is currently distributed directly through GitHub.

Add the Core SDK to your application's `pubspec.yaml`:

```yaml
dependencies:
  homigo_sdk:
    git:
      url: https://github.com/traikeyy-cmd/homigo-sdk.git
      ref: v1.0.0
```

Then run:

```bash
flutter pub get
```

During development, `main` can be used instead of a release tag:

```yaml
dependencies:
  homigo_sdk:
    git:
      url: https://github.com/traikeyy-cmd/homigo-sdk.git
      ref: main
```

## Basic Initialization

The recommended entry point is `HomiGoBootstrap`.

```dart
import 'package:flutter/material.dart';
import 'package:homigo_sdk/homigo_sdk.dart';

Future<void> main() async {
  await HomiGoBootstrap.initialize(
    config: HomiGoBootstrapConfig(
      sdkConfig: const HomiGoConfig(
        appName: 'My HomiGo App',
        environment: HomiGoEnvironment.production,
        themeMode: ThemeMode.system,
      ),
    ),
  );

  runApp(const MyApp());
}
```

## Theme

Use the HomiGo theme directly with `MaterialApp`:

```dart
MaterialApp(
  theme: HomiGoTheme.light(),
  darkTheme: HomiGoTheme.dark(),
  themeMode: HomiGoTheme.mode,
);
```

The theme uses the brand configured through `HomiGoConfig`.

## Branding

Custom branding can be supplied through `HomiGoBrand`:

```dart
const config = HomiGoConfig(
  appName: 'My App',
  brand: HomiGoBrand(
    primaryColor: Colors.blue,
    secondaryColor: Colors.cyan,
  ),
);
```

## Networking

An API base URL can be registered during bootstrap:

```dart
await HomiGoBootstrap.initialize(
  config: HomiGoBootstrapConfig(
    sdkConfig: const HomiGoConfig(
      appName: 'My App',
    ),
    apiBaseUrl: 'https://api.example.com',
  ),
);
```

The registered network client is available through:

```dart
final network = HomiGoServices.network;
```

The production networking layer supports:

- Retry policies
- Exponential backoff
- Timeouts
- Offline guards
- Network interceptors
- Token refresh coordination
- Request cancellation
- Centralized API error handling

## Result Handling

Operations can use `HomiGoResult<T>` to represent success and failure without exposing raw exceptions to higher application layers.

```dart
final result = await HomiGoErrorMapper.guard(
  () async {
    return 'HomiGo';
  },
);

if (result.isSuccess) {
  final value = result.dataOrNull;
} else {
  final failure = result.failureOrNull;
}
```

## Diagnostics

A diagnostic snapshot can be generated with:

```dart
final snapshot = HomiGoDiagnostics.snapshot();

print(snapshot.toMap());
```

A runtime health check is also available:

```dart
final report = await HomiGoHealthCheck.run();
```

## Firebase Companion Package

Firebase is intentionally kept outside the Core SDK.

This prevents applications that do not use Firebase from inheriting Firebase dependencies.

The optional package is located at:

```text
packages/homigo_sdk_firebase
```

To use it directly from this repository:

```yaml
dependencies:
  homigo_sdk_firebase:
    git:
      url: https://github.com/traikeyy-cmd/homigo-sdk.git
      ref: v1.0.0
      path: packages/homigo_sdk_firebase
```

## Firebase Features

The companion package provides integrations for:

- Firebase Core
- Firebase Authentication
- Firebase Cloud Messaging
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config

Basic initialization:

```dart
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';

await HomiGoFirebase.initialize();
```

Applications configured with FlutterFire can pass platform-specific Firebase options:

```dart
await HomiGoFirebase.initialize(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Firebase project configuration remains the responsibility of the host application.

Depending on the platform and setup, this may include:

- `google-services.json`
- `GoogleService-Info.plist`
- Generated `firebase_options.dart`

The SDK does not embed application-specific Firebase credentials.

## Firebase With Unified Bootstrap

Firebase can be initialized after the Core SDK through the bootstrap hook:

```dart
await HomiGoBootstrap.initialize(
  config: HomiGoBootstrapConfig(
    sdkConfig: const HomiGoConfig(
      appName: 'My HomiGo App',
    ),
    afterCoreInitialize: () async {
      await HomiGoFirebase.initialize();
    },
  ),
);
```

## Example Application

A runnable Flutter application is available in:

```text
example/
```

Run it with:

```bash
cd example
flutter pub get
flutter run
```

## Package Structure

```text
homigo-sdk/
├── lib/
│   ├── homigo_sdk.dart
│   └── src/
│       ├── adapters/
│       ├── bootstrap/
│       ├── core/
│       ├── design_system/
│       ├── platform/
│       └── widgets/
├── packages/
│   └── homigo_sdk_firebase/
├── example/
├── test/
└── .github/
    └── workflows/
```

## Development

Get dependencies:

```bash
flutter pub get
```

Format:

```bash
dart format lib test
```

Analyze:

```bash
flutter analyze lib test
```

Run tests:

```bash
flutter test
```

## Firebase Package Validation

```bash
cd packages/homigo_sdk_firebase

flutter pub get
flutter analyze
flutter test
```

## Continuous Integration

GitHub Actions validates the Core SDK and Firebase companion package independently.

The CI pipeline performs:

- Dependency resolution
- Static analysis
- Automated tests

## SDK Requirements

- Dart `>=3.11.0 <4.0.0`
- Flutter compatible with Dart 3.11 or newer

## Distribution

The package is currently configured with:

```yaml
publish_to: "none"
```

HomiGo SDK is distributed through Git repositories rather than pub.dev.

## License

HomiGo SDK is proprietary software.

Copyright © 2026 HomiGo. All rights reserved.
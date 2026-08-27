# HomiGo SDK

HomiGo SDK is a reusable Flutter foundation for building consistent, production-ready applications.

It provides a shared native design system, reusable UI primitives, platform adapters, core application services, networking infrastructure, reliability tools, and optional Firebase integrations.

## Version

Current release: **1.1.0**

## Native Design System

HomiGo 1.1.0 uses a lightweight native UI language built around solid surfaces, elevated icon tiles, soft accent colors, subtle borders and shadows, and short micro-animations.

The design system intentionally avoids runtime glass/blur effects such as `BackdropFilter` and `ImageFilter.blur` in HomiGo components.

Core design tokens include:

- `HomiGoColors`
- `HomiGoSpacing`
- `HomiGoRadius`
- `HomiGoTypography`
- `HomiGoMotion`
- `HomiGoElevation`

Core visual primitives include:

- `HomiGoNativeSurface`
- `HomiGoCard`
- `HomiGoElevatedIcon`
- `HomiGoButton`
- `HomiGoTextField`
- `HomiGoAgreementTile`
- `HomiGoCheckbox`
- `HomiGoSwitch`
- `HomiGoRadio`
- `HomiGoSegmentedControl`
- `HomiGoStatusBadge`
- `HomiGoProgressBar`
- `HomiGoStepper`

HomiGo SDK is a **toolkit, not an application template**. Applications decide their own navigation, screens, routes, data models, card content, dashboards, and feature structure. HomiGo components provide the visual language and interaction behavior used to compose those application-specific interfaces.

For example, an order card, clinic patient card, finance card, or project card can all be built from the same `HomiGoCard`, `HomiGoElevatedIcon`, status, typography, spacing, and action primitives without the SDK knowing the application's domain.

## Compatibility

The 1.1.0 release keeps legacy public names so existing applications can migrate without a breaking release.

- `HomiGoGlassCard` delegates to `HomiGoCard`.
- `HomiGoLiquidSegmentedControl` delegates to `HomiGoSegmentedControl`.
- `HomiGoLiquidSurface` is a compatibility wrapper around the native surface.
- The legacy `homigo_liquid_controls.dart` path re-exports the canonical native checkbox, switch, and radio controls.

Legacy `blur`, `opacity`, and glass-related configuration fields remain available for source compatibility where applicable, but HomiGo's native component implementation no longer renders glass blur.

## Other UI Components

HomiGo SDK also includes reusable components for:

- Dropdowns and searchable dropdowns
- Number and phone inputs
- Tabs
- List tiles and expansion tiles
- Chips, badges, and avatars
- App bars and navigation bars
- Drawers
- Bottom sheets and dialogs
- Snackbars
- Menus and tooltips
- Sliders and range sliders
- Progress indicators
- Date and time pickers
- Skeleton loading
- Loading, empty, and error states

## Core Services

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

## Platform Adapters

- SharedPreferences
- Flutter Secure Storage
- HTTP transport
- Connectivity Plus
- Permission Handler
- File Picker
- Image Picker
- Device information
- Package information

## Production Infrastructure

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

Add HomiGo SDK to your Flutter project:

```bash
flutter pub add homigo_sdk
```

Or add it manually to your application's `pubspec.yaml`:

```yaml
dependencies:
  homigo_sdk: ^1.1.0
```

Then run:

```bash
flutter pub get
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

## Compose Application-Specific UI

Use HomiGo primitives inside ordinary Flutter layout widgets. The SDK does not require a specific dashboard or screen structure.

```dart
HomiGoCard(
  child: Row(
    children: [
      const HomiGoElevatedIcon(icon: Icons.schedule_rounded),
      const SizedBox(width: HomiGoSpacing.md),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request #1042'),
            const SizedBox(height: HomiGoSpacing.sm),
            const HomiGoStatusBadge(
              label: 'In progress',
              status: HomiGoStatus.info,
            ),
          ],
        ),
      ),
    ],
  ),
)
```

For a small filter or view selector, use the component directly rather than wrapping it in a predefined screen:

```dart
HomiGoSegmentedControl<String>(
  value: selectedView,
  items: const [
    HomiGoSegmentItem(value: 'grid', label: 'Grid'),
    HomiGoSegmentItem(value: 'list', label: 'List'),
  ],
  onChanged: (value) {
    setState(() => selectedView = value);
  },
)
```

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
    sdkConfig: const HomiGoConfig(appName: 'My App'),
    apiBaseUrl: 'https://api.example.com',
  ),
);
```

The registered network client is available through:

```dart
final network = HomiGoServices.network;
```

The production networking layer supports retries, exponential backoff, timeouts, offline guards, interceptors, token refresh coordination, cancellation, and centralized API error handling.

## Result Handling

Operations can use `HomiGoResult<T>` to represent success and failure without exposing raw exceptions to higher application layers.

```dart
final result = await HomiGoErrorMapper.guard(
  () async => 'HomiGo',
);

if (result.isSuccess) {
  final value = result.dataOrNull;
} else {
  final failure = result.failureOrNull;
}
```

## Diagnostics

```dart
final snapshot = HomiGoDiagnostics.snapshot();
print(snapshot.toMap());

final report = await HomiGoHealthCheck.run();
```

## Firebase Companion Package

Firebase integrations are intentionally kept outside the Core SDK so applications that do not use Firebase do not inherit Firebase dependencies.

```yaml
dependencies:
  homigo_sdk: ^1.1.0
  homigo_sdk_firebase: ^1.0.0
```

The companion package provides Firebase Core, Authentication, Cloud Messaging, Analytics, Crashlytics, and Remote Config integrations.

```dart
import 'package:homigo_sdk_firebase/homigo_sdk_firebase.dart';

await HomiGoFirebase.initialize();
```

Applications configured with FlutterFire can pass platform-specific options:

```dart
await HomiGoFirebase.initialize(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Firebase project configuration remains the responsibility of the host application. HomiGo SDK Firebase does not embed application-specific Firebase credentials.

## Example Application

A runnable Flutter application is available in `example/` and demonstrates composition with the public native primitives rather than a predefined application shell.

```bash
cd example
flutter pub get
flutter run
```

## Development

```bash
flutter pub get
dart format lib test example/lib
flutter analyze
flutter test
dart pub publish --dry-run
```

Firebase package validation:

```bash
cd packages/homigo_sdk_firebase
flutter pub get
flutter analyze
flutter test
```

## Continuous Integration

GitHub Actions validates formatting, static analysis, automated tests, and Core SDK publication readiness. The Firebase companion package is validated independently.

## SDK Requirements

- Dart `>=3.11.0 <4.0.0`
- Flutter compatible with Dart 3.11 or newer

Platform availability can depend on the configuration and platform support of the underlying Flutter plugins.

## Issues

Report bugs and request features through the GitHub issue tracker.

## License

HomiGo SDK is available under the BSD 3-Clause License.

Copyright © 2026 HomiGo.

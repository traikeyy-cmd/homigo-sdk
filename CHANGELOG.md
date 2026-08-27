# Changelog

## 1.1.0

### Added

- Introduced the official `HomiGoCard` generic card primitive.
- Introduced the official `HomiGoSegmentedControl` API.
- Added canonical native `HomiGoCheckbox`, `HomiGoSwitch`, and `HomiGoRadio` exports.
- Added `HomiGoMotion` tokens for shared interaction timings, curves, and press scales.
- Added `HomiGoElevation` tokens for shared native shadow values.
- Added compatibility and native-design regression tests.

### Changed

- Migrated the HomiGo visual system to lightweight native solid surfaces with subtle borders, shadows, elevated icons, and micro-animations.
- Removed runtime Glass/Liquid blur from HomiGo component internals.
- Standardized core cards, buttons, navigation, selection controls, actions, inputs, progress components, and overlays on shared design tokens where values match the established visual system.
- Updated the example application to demonstrate composing application-specific UI from generic HomiGo primitives rather than relying on a predefined application structure.
- Updated documentation for the Native UI toolkit architecture.

### Compatibility

- `HomiGoGlassCard` remains available and delegates to `HomiGoCard`.
- `HomiGoLiquidSegmentedControl` remains available and delegates to `HomiGoSegmentedControl`.
- `HomiGoLiquidSurface` remains available as a compatibility wrapper around the native surface.
- The legacy `homigo_liquid_controls.dart` import path re-exports the canonical native selection controls.
- Legacy glass-related configuration fields remain source-compatible for this minor release.

## 1.0.1

### Changed

- Improved compatibility with Flutter environments using Dart 3.11 or newer.
- Changed `flutter_secure_storage` dependency to `^10.3.1`.
- Changed `permission_handler` dependency to `^12.0.3`.
- Updated the example application dependencies to use HomiGo SDK 1.0.1.

## 1.0.0

Initial production release of HomiGo SDK.

### Added

- Central SDK configuration and branding
- Complete design token system
- Material 3 light, dark, and system themes
- Liquid / Water Glass UI system
- Reusable UI component library
- Edge-to-edge System UI infrastructure
- Safe area and keyboard inset handling
- Storage and secure storage abstractions
- SharedPreferences adapter
- Flutter Secure Storage adapter
- Session management
- HTTP network client
- Connectivity abstraction and adapter
- Permissions abstraction and adapter
- Localization foundation
- Validation and formatting utilities
- Device information adapter
- Package information adapter
- File picker adapter
- Image picker adapter
- Retry policies
- Exponential backoff
- Timeout policies
- Cancellation tokens
- Network interceptors
- Offline request protection
- Token refresh coordination
- Central error mapping
- `HomiGoResult<T>`
- Application lifecycle monitoring
- Diagnostics
- Health checks
- Unified `HomiGoBootstrap`
- Optional Firebase companion package
- Firebase Authentication integration
- Firebase Cloud Messaging integration
- Firebase Analytics integration
- Firebase Crashlytics integration
- Firebase Remote Config integration
- Automated Core SDK and Firebase SDK CI
- Example Flutter application

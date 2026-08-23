library;

// ============================================================
// HomiGo SDK - Public API
// ============================================================

// Core
export 'src/core/config/homigo_brand.dart';
export 'src/core/config/homigo_config.dart';
export 'src/core/config/homigo_sdk_core.dart';

// Platform - System UI
export 'src/platform/system_ui/homigo_system_ui.dart';
export 'src/platform/system_ui/homigo_insets.dart';

// Core Services
export 'src/core/config/homigo_services.dart';
export 'src/core/logger/homigo_logger.dart';
export 'src/core/environment/homigo_environment.dart';
export 'src/core/validation/homigo_validators.dart';
export 'src/core/formatting/homigo_formatters.dart';
export 'src/core/storage/homigo_storage.dart';
export 'src/core/session/homigo_session.dart';
export 'src/core/network/homigo_api_models.dart';
export 'src/core/network/homigo_network_client.dart';
export 'src/core/connectivity/homigo_connectivity.dart';
export 'src/core/localization/homigo_localization.dart';
export 'src/core/permissions/homigo_permissions.dart';

// Platform Adapters
export 'src/adapters/homigo_platform_adapters.dart';
export 'src/adapters/storage/homigo_shared_preferences_storage.dart';
export 'src/adapters/storage/homigo_flutter_secure_storage.dart';
export 'src/adapters/network/homigo_http_transport.dart';
export 'src/adapters/connectivity/homigo_connectivity_plus_adapter.dart';
export 'src/adapters/permissions/homigo_permission_handler_adapter.dart';
export 'src/adapters/files/homigo_file_picker.dart';
export 'src/adapters/media/homigo_image_picker.dart';
export 'src/adapters/device/homigo_device_info.dart';
export 'src/adapters/device/homigo_package_info.dart';

// Design Tokens
export 'src/design_system/tokens/homigo_colors.dart';
export 'src/design_system/tokens/homigo_radius.dart';
export 'src/design_system/tokens/homigo_spacing.dart';
export 'src/design_system/tokens/homigo_typography.dart';

// Theme
export 'src/design_system/theme/homigo_theme.dart';

// Design System - Liquid
export 'src/design_system/liquid/homigo_liquid_surface.dart';

// Widgets - Cards
export 'src/widgets/cards/homigo_glass_card.dart';

// Widgets - Buttons
export 'src/widgets/buttons/homigo_button.dart';

// Widgets - Inputs
export 'src/widgets/inputs/homigo_text_field.dart';
export 'src/widgets/inputs/homigo_dropdown.dart';
export 'src/widgets/inputs/homigo_advanced_inputs.dart';

// Widgets - Selection
export 'src/widgets/selection/homigo_liquid_segmented_control.dart';
export 'src/widgets/selection/homigo_liquid_controls.dart';
export 'src/widgets/selection/homigo_tabs.dart';

// Widgets - Navigation
export 'src/widgets/navigation/homigo_navigation_bar.dart';
export 'src/widgets/navigation/homigo_navigation_extras.dart';

// Widgets - Overlays
export 'src/widgets/overlays/homigo_bottom_sheet.dart';
export 'src/widgets/overlays/homigo_dialog.dart';

// Widgets - Feedback
export 'src/widgets/feedback/homigo_snackbar.dart';
export 'src/widgets/feedback/homigo_states.dart';

// Widgets - Display
export 'src/widgets/display/homigo_display_components.dart';

// Widgets - Actions
export 'src/widgets/actions/homigo_action_components.dart';

// Widgets - Pickers
export 'src/widgets/pickers/homigo_pickers.dart';

// Widgets - Progress
export 'src/widgets/progress/homigo_progress_components.dart';

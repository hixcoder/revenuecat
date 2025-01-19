import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Configuration class for RevenueCat integration.
/// Contains all necessary configuration settings and initialization logic.
class RevenueCatConfig {
  // Private constructor to prevent instantiation
  RevenueCatConfig._();

  /// API key for Android platform
  /// Replace this with your actual Android API key from RevenueCat dashboard
  static const String _androidKey = "goog_YOUR_ANDROID_KEY";

  /// API key for iOS platform
  /// Replace this with your actual iOS API key from RevenueCat dashboard
  static const String _iosKey = "appl_wZPlJBrmeIbJlHbhKOJMJKxrsSE";

  /// Key used to identify the pro entitlement in RevenueCat dashboard
  /// This should match exactly with your entitlement identifier in RevenueCat
  static const String proEntitlementKey = 'pro';

  /// Initializes RevenueCat SDK with appropriate configuration
  /// This should be called before using any RevenueCat functionality
  ///
  /// Typically called in main() function before runApp()
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await RevenueCatConfig.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    // Set debug log level for development
    // Consider changing this for production
    await Purchases.setLogLevel(LogLevel.debug);

    // Determine which API key to use based on platform
    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_androidKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_iosKey);
    }

    // Configure RevenueCat SDK if configuration is available
    if (configuration != null) {
      await Purchases.configure(configuration);
      print('RevenueCat configured successfully');
    }
  }
}

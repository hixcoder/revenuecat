import 'package:purchases_flutter/purchases_flutter.dart';
import 'revenue_cat_config.dart';

/// Service class that handles all RevenueCat-related operations
/// Implements Singleton pattern to ensure only one instance exists
class RevenueCatService {
  // Singleton instance
  static final RevenueCatService _instance = RevenueCatService._internal();

  /// Factory constructor that returns singleton instance
  factory RevenueCatService() => _instance;

  // Private constructor
  RevenueCatService._internal();

  /// Checks if user has active pro status
  ///
  /// Returns [true] if user has active pro entitlement
  /// Returns [false] if user doesn't have pro entitlement or if check fails
  ///
  /// Example:
  /// ```dart
  /// final isPro = await RevenueCatService().checkProStatus();
  /// if (isPro) {
  ///   // Show pro features
  /// }
  /// ```
  Future<bool> checkProStatus() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.proEntitlementKey);
    } catch (e) {
      print("Failed to check purchase status: $e");
      return false;
    }
  }

  /// Fetches available offerings from RevenueCat
  ///
  /// Returns [Offerings] object if successful
  /// Returns [null] if fetch fails
  ///
  /// Example:
  /// ```dart
  /// final offerings = await RevenueCatService().getOfferings();
  /// if (offerings?.current != null) {
  ///   // Show available packages
  /// }
  /// ```
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      print("Failed to get offerings: $e");
      return null;
    }
  }

  /// Processes the purchase of a specific package
  ///
  /// Parameters:
  ///   [package] - The package to purchase
  ///
  /// Returns [CustomerInfo] if purchase is successful
  /// Throws an exception if purchase fails
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final result = await RevenueCatService().purchasePackage(package);
  ///   // Handle successful purchase
  /// } catch (e) {
  ///   // Handle purchase error
  /// }
  /// ```
  Future<CustomerInfo?> purchasePackage(Package package) async {
    try {
      return await Purchases.purchasePackage(package);
    } catch (e) {
      print("Purchase failed: $e");
      rethrow;
    }
  }

  /// Adds a listener for customer info updates
  ///
  /// This is useful for updating UI when subscription status changes
  ///
  /// Parameters:
  ///   [listener] - Callback function that receives updated CustomerInfo
  ///
  /// Remember to remove listener when no longer needed
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  /// Removes a previously added customer info update listener
  ///
  /// Should be called in dispose() method of widgets
  ///
  /// Parameters:
  ///   [listener] - The listener to remove
  void removeCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  /// Restores previous purchases for the current user
  ///
  /// Useful when user reinstalls the app or switches devices
  ///
  /// Returns [CustomerInfo] if restore is successful
  /// Returns [null] if restore fails
  Future<CustomerInfo?> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (e) {
      print("Failed to restore purchases: $e");
      return null;
    }
  }
}

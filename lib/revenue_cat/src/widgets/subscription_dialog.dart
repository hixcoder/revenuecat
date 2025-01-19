import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// A dialog widget that displays available subscription packages
///
/// Shows a list of packages with their titles and prices
/// Returns the selected package when user makes a choice
class SubscriptionDialog extends StatelessWidget {
  /// List of available packages to display
  final List<Package> packages;

  /// Optional custom styling for dialog title
  final TextStyle? titleStyle;

  /// Optional custom styling for package buttons
  final ButtonStyle? buttonStyle;

  const SubscriptionDialog({
    super.key,
    required this.packages,
    this.titleStyle,
    this.buttonStyle,
  });

  /// Static method to show the dialog
  ///
  /// Returns selected [Package] or null if dialog is dismissed
  ///
  /// Example:
  /// ```dart
  /// final package = await SubscriptionDialog.show(
  ///   context,
  ///   offerings.current!.availablePackages,
  /// );
  /// if (package != null) {
  ///   // Handle package selection
  /// }
  /// ```
  static Future<Package?> show(
    BuildContext context,
    List<Package> packages, {
    TextStyle? titleStyle,
    ButtonStyle? buttonStyle,
  }) {
    return showDialog<Package>(
      context: context,
      builder: (context) => SubscriptionDialog(
        packages: packages,
        titleStyle: titleStyle,
        buttonStyle: buttonStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose Subscription',
        style: titleStyle ?? Theme.of(context).textTheme.titleLarge,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: packages.map((package) {
            // Format the package information for display
            final title = package.storeProduct.title;
            final price = package.storeProduct.priceString;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () => Navigator.of(context).pop(package),
                child: Text(
                  '$title\n$price',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

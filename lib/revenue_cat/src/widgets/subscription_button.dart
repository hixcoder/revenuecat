import 'package:flutter/material.dart';
import '../revenue_cat_service.dart';
import 'subscription_dialog.dart';

/// A button widget that handles the complete subscription flow
///
/// Shows subscription options when pressed and handles the purchase process
/// Provides callbacks for success and error states
class SubscriptionButton extends StatefulWidget {
  /// Callback triggered when subscription is successfully completed
  final VoidCallback? onSubscriptionComplete;

  /// Callback triggered when an error occurs during subscription process
  final void Function(String)? onError;

  /// Widget to show while subscription is processing
  final Widget? loadingWidget;

  /// The child widget to display in the button
  final Widget child;

  /// Optional custom style for the button
  final ButtonStyle? style;

  /// Optional custom style for the subscription dialog title
  final TextStyle? dialogTitleStyle;

  /// Optional custom style for the subscription dialog buttons
  final ButtonStyle? dialogButtonStyle;

  const SubscriptionButton({
    super.key,
    this.onSubscriptionComplete,
    this.onError,
    this.loadingWidget,
    required this.child,
    this.style,
    this.dialogTitleStyle,
    this.dialogButtonStyle,
  });

  @override
  State<SubscriptionButton> createState() => _SubscriptionButtonState();
}

class _SubscriptionButtonState extends State<SubscriptionButton> {
  // Instance of RevenueCatService to handle subscription operations
  final _subscriptionService = RevenueCatService();
  bool _isLoading = false;

  /// Handles the complete subscription flow
  ///
  /// 1. Fetches available offerings
  /// 2. Shows subscription dialog
  /// 3. Processes selected package
  /// 4. Handles success/error states
  Future<void> _handleSubscription() async {
    setState(() => _isLoading = true);

    try {
      // Get available offerings
      final offerings = await _subscriptionService.getOfferings();
      if (offerings?.current == null) {
        widget.onError?.call("No offerings available");
        return;
      }

      // Show subscription dialog and get selected package
      final selectedPackage = await SubscriptionDialog.show(
        context,
        offerings!.current!.availablePackages,
        titleStyle: widget.dialogTitleStyle,
        buttonStyle: widget.dialogButtonStyle,
      );

      // Handle package selection
      if (selectedPackage == null) return;

      // Process the purchase
      final purchaseResult =
          await _subscriptionService.purchasePackage(selectedPackage);
      if (purchaseResult?.entitlements.active.isNotEmpty ?? false) {
        widget.onSubscriptionComplete?.call();
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? const CircularProgressIndicator();
    }

    return ElevatedButton(
      style: widget.style,
      onPressed: _handleSubscription,
      child: widget.child,
    );
  }
}

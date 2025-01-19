# Flutter RevenueCat Integration

A reusable implementation of RevenueCat in-app purchases and subscriptions for Flutter applications. This package provides a clean, modular approach to implementing RevenueCat with minimal boilerplate code.

## Features

- 🔄 Easy subscription management
- 🎯 Clean, modular architecture
- 🛠️ Reusable components
- 📱 Platform-specific configuration
- 🔒 Singleton service pattern
- 🎨 Customizable UI components

## Installation

1. Add the RevenueCat dependency to your `pubspec.yaml`:

```yaml
dependencies:
  purchases_flutter: ^6.0.0
```

2. Copy the `revenue_cat` folder from this repository to your project's `lib` directory:

```
lib/
  revenue_cat/
    ├── revenue_cat.dart
    └── src/
        ├── revenue_cat_config.dart
        ├── revenue_cat_service.dart
        └── widgets/
            ├── subscription_dialog.dart
            └── subscription_button.dart
```

## Configuration

1. Update your RevenueCat API keys in `revenue_cat_config.dart`:

```dart
static const String _androidKey = "goog_YOUR_ANDROID_KEY";
static const String _iosKey = "appl_YOUR_IOS_KEY";
```

2. Initialize RevenueCat in your `main.dart`:

```dart
import 'revenue_cat/revenue_cat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatConfig.initialize();
  runApp(const MyApp());
}
```

## Usage

### Basic Implementation

1. Create a subscription button:

```dart
SubscriptionButton(
  onSubscriptionComplete: () => print('Subscribed!'),
  onError: (error) => print('Error: $error'),
  child: const Text('Subscribe Now'),
)
```

2. Check subscription status:

```dart
final revenueCatService = RevenueCatService();
final isPro = await revenueCatService.checkProStatus();
```

3. Listen for subscription changes:

```dart
@override
void initState() {
  super.initState();
  revenueCatService.addCustomerInfoUpdateListener(_customerInfoUpdateListener);
}

void _customerInfoUpdateListener(CustomerInfo customerInfo) {
  final isPro = customerInfo.entitlements.active.containsKey(RevenueCatConfig.proEntitlementKey);
  // Update UI based on status
}
```

### Complete Example

Here's a minimal example showing how to implement a pro feature:

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _revenueCatService = RevenueCatService();
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _checkProStatus();
    _revenueCatService.addCustomerInfoUpdateListener(_updateProStatus);
  }

  Future<void> _checkProStatus() async {
    final isPro = await _revenueCatService.checkProStatus();
    setState(() => _isPro = isPro);
  }

  void _updateProStatus(CustomerInfo customerInfo) {
    setState(() {
      _isPro = customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.proEntitlementKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isPro
      ? ProFeatureWidget()
      : SubscriptionButton(
          onSubscriptionComplete: () => print('Subscribed!'),
          child: Text('Unlock Pro'),
        );
  }
}
```

## Components

### RevenueCatConfig

Handles initialization and configuration:

- Platform-specific API keys
- SDK initialization
- Debug logging setup

### RevenueCatService

Manages subscription logic:

- Singleton pattern for consistent state
- Purchase handling
- Status checking
- Subscription listeners

### SubscriptionButton

Reusable UI component:

- Handles purchase flow
- Loading states
- Error handling
- Customizable appearance

### SubscriptionDialog

Displays subscription options:

- Dynamic package listing
- Price display
- Customizable styling

## Error Handling

The implementation includes comprehensive error handling:

```dart
SubscriptionButton(
  onSubscriptionComplete: () {
    // Handle successful subscription
  },
  onError: (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  },
  child: Text('Subscribe'),
)
```

## Best Practices

1. Always initialize RevenueCat before using any features
2. Use the singleton RevenueCatService instance throughout your app
3. Remove subscription listeners in dispose() method
4. Handle loading and error states appropriately
5. Store API keys securely (consider using environment variables)

## Troubleshooting

Common issues and solutions:

1. **No Offerings Available**

   - Check RevenueCat dashboard configuration
   - Verify API keys are correct
   - Ensure products are properly configured in App Store/Play Store

2. **Purchase Failed**

   - Check internet connectivity
   - Verify sandbox testing account (iOS)
   - Confirm product IDs match store listings

3. **Status Not Updating**
   - Ensure listeners are properly set up
   - Check entitlement identifier matches RevenueCat dashboard

## License

This implementation is provided under the MIT License. Feel free to use and modify as needed.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

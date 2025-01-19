import 'package:flutter/material.dart';
// Import our RevenueCat components
import 'revenue_cat/revenue_cat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _revenueCatService = RevenueCatService();
  int _counter = 0;
  bool _isPro = false;

  @override
  void initState() {
    super.initState();
    _checkPurchaseStatus();
    _revenueCatService
        .addCustomerInfoUpdateListener(_customerInfoUpdateListener);
  }

  @override
  void dispose() {
    _revenueCatService
        .removeCustomerInfoUpdateListener(_customerInfoUpdateListener);
    super.dispose();
  }

  Future<void> _checkPurchaseStatus() async {
    final isPro = await _revenueCatService.checkProStatus();
    setState(() => _isPro = isPro);
  }

  void _customerInfoUpdateListener(customerInfo) {
    setState(() {
      _isPro = customerInfo.entitlements.active
          .containsKey(RevenueCatConfig.proEntitlementKey);
    });
  }

  void _incrementCounter() {
    if (_isPro) {
      setState(() => _counter++);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isPro
                  ? 'Thank you for the subscription'
                  : "Subscribe to unlock counter!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (!_isPro)
              SubscriptionButton(
                onSubscriptionComplete: () =>
                    _showMessage("Purchase successful!"),
                onError: _showMessage,
                child: const Text('Subscribe Now'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isPro ? _incrementCounter : null,
        tooltip: _isPro ? 'Increment' : 'Subscribe to increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:upayments_sdk/upayments_sdk.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPayments SDK Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  late final UPaymentsClient _client;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _client = UPaymentsClient(
      config: const UPaymentsConfig(
        apiKey: 'jtest123',
        isSandbox: true,
      ),
    );
  }

  Future<void> _startCheckout() async {
    setState(() {
      _statusMessage = 'Creating charge...';
    });

    final chargeRequest = ChargeRequest(
      notificationUrl: 'https://example.com/notification',
      returnUrl: 'https://example.com/return',
      cancelUrl: 'https://example.com/cancel',
      language: 'en',
      customer: Customer(
        uniqueId: '9223372036854755',
        name: 'Test Customer',
        email: 'customer@example.com',
        mobile: '+96512345678',
      ),
      order: Order(
        id: 'order_12345',
        reference: 'REF-001',
        description: 'Demo purchase',
        currency: 'KWD',
        amount: 10.00,
      ),
      products: [
        Product(
          name: 'Demo Item',
          description: 'A sample product',
          price: 10.00,
          quantity: 1,
        ),
      ],
      referenceId: 'ref_12345',
    );

    try {
      final response = await _client.charge.createCharge(chargeRequest);
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => UPaymentsCheckoutPage(
            link: response.link,
            returnUrl: chargeRequest.returnUrl!,
            cancelUrl: chargeRequest.cancelUrl!,
            onNavigationFinished: (result) {
              setState(() {
                _statusMessage = result.cancelled
                    ? 'Checkout cancelled with track_id ${result.trackId}'
                    : 'Checkout completed with track_id ${result.trackId}';
              });
            },
          ),
        ),
      );
    } catch (error) {
      setState(() {
        _statusMessage = 'Checkout creation failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UPayments SDK Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'This example app demonstrates a basic charge flow using the UPayments SDK.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCheckout,
              child: const Text('Start Checkout'),
            ),
            const SizedBox(height: 20),
            if (_statusMessage != null) Text(_statusMessage!),
          ],
        ),
      ),
    );
  }
}

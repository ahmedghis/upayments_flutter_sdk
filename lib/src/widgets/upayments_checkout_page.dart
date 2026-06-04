import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UPaymentsCheckoutResult {
  final String trackId;
  final bool cancelled;

  UPaymentsCheckoutResult({required this.trackId, this.cancelled = false});
}

class UPaymentsCheckoutPage extends StatefulWidget {
  final String link;
  final String returnUrl;
  final String cancelUrl;
  final ValueChanged<UPaymentsCheckoutResult> onNavigationFinished;

  const UPaymentsCheckoutPage({
    super.key,
    required this.link,
    required this.returnUrl,
    required this.cancelUrl,
    required this.onNavigationFinished,
  });

  @override
  State<UPaymentsCheckoutPage> createState() => _UPaymentsCheckoutPageState();
}

class _UPaymentsCheckoutPageState extends State<UPaymentsCheckoutPage> {
  late final WebViewController _controller;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    final params = const PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            _handleNavigation(changeUrl: request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
  }

  void _handleNavigation({required String changeUrl}) {
    if (_hasCompleted) {
      return;
    }
    if (changeUrl.startsWith(widget.returnUrl) ||
        changeUrl.startsWith(widget.cancelUrl)) {
      final trackId = _extractTrackId(changeUrl);
      if (trackId != null) {
        _hasCompleted = true;
        widget.onNavigationFinished(
          UPaymentsCheckoutResult(
            trackId: trackId,
            cancelled: changeUrl.startsWith(widget.cancelUrl),
          ),
        );
      }
    }
  }

  String? _extractTrackId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    return uri.queryParameters['track_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UPayments Checkout')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

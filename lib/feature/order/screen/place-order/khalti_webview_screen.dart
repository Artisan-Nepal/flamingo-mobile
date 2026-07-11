import 'package:flamingo/shared/constant/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Opens Khalti's hosted checkout page and watches for the redirect back to
// our return_url (a scheme we own, never actually resolvable/loaded - see
// PaymentMethod.khaltiReturnUrlScheme). Pops with {'pidx': ..., 'status': ...}
// parsed from that redirect's query params on completion, or null if the
// customer closes the WebView before finishing.
class KhaltiWebViewScreen extends StatefulWidget {
  const KhaltiWebViewScreen({super.key, required this.paymentUrl});

  final String paymentUrl;

  @override
  State<KhaltiWebViewScreen> createState() => _KhaltiWebViewScreenState();
}

class _KhaltiWebViewScreenState extends State<KhaltiWebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _progress = progress / 100);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(PaymentMethod.khaltiReturnUrlScheme)) {
              final uri = Uri.parse(request.url);
              Navigator.pop(context, {
                'pidx': uri.queryParameters['pidx'],
                'status': uri.queryParameters['status'],
              });
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khalti Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
      body: Column(
        children: [
          if (_progress < 1)
            LinearProgressIndicator(value: _progress == 0 ? null : _progress),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReportPage extends StatefulWidget {

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State {
  WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSe239duXJWTAhH-0QRyGGBFULgxqDYoSxXvdPlW5tMtI6QVWA/viewform'));
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: 
      isDarkMode ? 
      AppBar(title: const Text('Report Form'), iconTheme: IconThemeData(color: Colors.white)) :
      AppBar(title: const Text('Report Form'), iconTheme: IconThemeData(color: Colors.black)),
      body: WebViewWidget(controller: controller),
    );
  }
}
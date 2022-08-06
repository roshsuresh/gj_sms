import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewGo extends StatelessWidget {
  final String url;
  const WebViewGo({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url,
        ),
      ),
    );
  }
}

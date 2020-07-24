import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProtocolPrivacy extends StatefulWidget {
  final String title;
  const ProtocolPrivacy({Key key, this.title}) : super(key: key);

  @override
  _ProtocolPrivacyState createState() => _ProtocolPrivacyState();
}

class _ProtocolPrivacyState extends State<ProtocolPrivacy> {
  Completer<WebViewController> controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    initAssets();
  }

  void initAssets() async {
    String path = '';
    if (widget.title != '用户协议') {
      path = 'assets/file/protocol.html';
    } else {
      path = 'assets/file/privacy.html';
    }
    String content = await rootBundle.loadString(path);
    String contentBase64 = base64Encode(const Utf8Encoder().convert(content));
    String url = 'data:text/html;base64,$contentBase64';
    controller.future.then((value) {
      value.loadUrl(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
        titleSpacing: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }
}

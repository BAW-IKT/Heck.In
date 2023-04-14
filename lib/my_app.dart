import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'WebView Example',
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late bool _isLoadingPage;

  @override
  void initState() {
    super.initState();
    _isLoadingPage = false;
  }

  final WebViewController controller = WebViewController()
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
    );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Example'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('WebView Menu'),
            ),
            ListTile(
              title: const Text('Google'),
              onTap: () {
                _loadPage('https://www.google.com');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Flutter'),
              onTap: () {
                _loadPage('https://flutter.dev');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          _isLoadingPage
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(),
        ],
      ),
    );
  }

  void _loadPage(String url) {
    setState(() {
      _isLoadingPage = true;
    });
    controller
        .loadRequest(Uri.parse(url));
    setState(() {
      _isLoadingPage = false;
    });
  }
}


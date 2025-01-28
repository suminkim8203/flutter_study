import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse(
    'https://velog.io/@lino0707/Flutter-%EC%9B%B9%EB%B7%B0-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0');

class HomeScreen extends StatelessWidget {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(homeUrl);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 디자인을 편하게 만들어준다...
        backgroundColor: Colors.orange,
        title: Text(
          'web view',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // 플렛폼 별로 정렬 다르게 되는 것 막기
        actions: [
          IconButton(
            onPressed: () {
              controller.loadRequest(homeUrl);
            },
            icon: Icon(
              Icons.home,
            ),
          )
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

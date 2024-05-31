import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'root.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            _loginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            try {
              String kakaoLoginUrl = await UserController.loginWithKakao();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KakaoLoginPage(kakaoLoginUrl: kakaoLoginUrl),
                ),
              );
            } catch (e) {
              print('Failed to login with Kakao: $e');
            }
          },
          child: Image.asset('assets/kakao.png'),
        ),
      );
}

class KakaoLoginPage extends StatefulWidget {
  final String kakaoLoginUrl;
  const KakaoLoginPage({super.key, required this.kakaoLoginUrl});

  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  WebViewController? _webViewController;
  bool _loading = false;
  @override
  void initState() {
    _webViewController = WebViewController();
    _loadWebView();
    super.initState();
  }

  void _loadWebView() async {
    try {
      String url = await UserController.loginWithKakao();
      String sessionID = ''; // 세션 ID 초기화

      _webViewController!
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptChannel(
          'LoggedInChannel',
          onMessageReceived: (JavaScriptMessage message) async {
            // 클라이언트에서 받은 메시지가 세션 ID인 경우
            sessionID = message.message;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('session_id', sessionID);
            print("loadWebView SessionId:$sessionID");

            // Close the web view
            Navigator.pop(context);

            // Navigate to your desired screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Root(selectedIndex: 0),
              ),
            );
          },
        )
        ..loadRequest(Uri.parse(url))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                _loading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _loading = false;
              });
            },
          ),
        );

      // Wait for the web view to finish loading
      // while (sessionID.isEmpty) {
      //   await Future.delayed(const Duration(milliseconds: 100)); // 잠시 기다림
      // }

      // Use the session ID here if needed
      print('Received session ID: $sessionID');

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed to load Kakao login URL: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController!,
          ),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

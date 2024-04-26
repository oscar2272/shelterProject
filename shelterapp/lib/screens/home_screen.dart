import 'package:flutter/material.dart';
import 'package:shelterapp/screens/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          right: 50,
          bottom: 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/logo.png'),
            TextField(
              decoration: InputDecoration(
                fillColor: const Color(0xFF99A2AD).withOpacity(0.1),
                filled: true,
                hintText: 'Enter your ID',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true, // 비밀번호 숨기기
              decoration: InputDecoration(
                fillColor: const Color(0xFF99A2AD).withOpacity(0.1),
                filled: true,
                hintText: 'Password',
                border: const OutlineInputBorder(), // 테두리 스타일
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Text('로그인'),
                ),
                const Text(
                  '/',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 여기에 로그인 로직을 추가하세요.
                  },
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

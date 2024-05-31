import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shelterapp/provider/user_provider.dart';
import 'package:shelterapp/screens/home_screen.dart';
import 'package:shelterapp/provider/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: 'baef4a7d6e5cbf4a34515363c0487e7e',
    javaScriptAppKey: '32f312d2fd31e79a62d8845b84df031c',
  );
  await NaverMapSdk.instance.initialize(clientId: 'zlbexkr3q4');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider<UserController>(
            create: (context) => UserController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  const MyApp({
    this.latitude,
    this.longitude,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFFBF9F9),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFBF9F9),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        //cardColor: const Color(0xFFF4EDDB),
      ),
      home: const HomeScreen(),
    );
  }
}

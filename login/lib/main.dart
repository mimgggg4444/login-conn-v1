import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/user_model.dart';
import 'screens/login_page.dart';
import 'screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  KakaoSdk.init(nativeAppKey: AppConfig.kakaoNativeKey); // Kakao SDK 초기화

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(
        nickname: '',
        profileimage: '',
      ),
      child: MaterialApp(
        home: FutureBuilder<bool>(
          future: _getLoginState(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : (snapshot.data == true)
                ? const MainPage()
                : const LoginPage();
          },
        ),
      ),
    );
  }
}

Future<bool> _getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogged') ?? false;
}

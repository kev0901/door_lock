import 'package:app/widget/loginField.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Door Lock',
      home: Main(title: 'Door Lock'),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isLoggedIn = false;

  @override
  void initState() {
    // if (isLoggedIn) {
    //   navigateToHomeScreen();
    // }
    // todo: remember me 체크. - 로딩
    // id/pw 정보 확인 - 로딩
    // 로그인 정상적으로 되는지 체크 - 로딩
    // Futurebuilder로 위의 정보들 따라 잠깐씩 로딩화면 넣어주기
    // token 생기면 계속. 안되면 그냥 화면 보여주기.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginField();
  }
}

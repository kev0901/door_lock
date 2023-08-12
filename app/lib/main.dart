import 'package:app/widget/homeScreen.dart';
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

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const HomeScreen();
      },
    ), (route) => false);
  }

  @override
  void initState() {
    if (isLoggedIn) {
      navigateToHomeScreen();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoginField();
    // return HomeScreen();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: IconButton(
    //       onPressed: () {
    //         navigateToHomeScreen();
    //       },
    //       icon: const Icon(Icons.check),
    //     ),
    //   ),
    // );
  }
}

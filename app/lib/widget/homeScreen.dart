import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final String localhost = 'http://127.0.0.1:3000';
  Uri getUri(String cmd) {
    return Uri.parse('$localhost/$cmd');
  }

  void onUnlock(BuildContext context) async {
    final response = await http.get(getUri('unlock'));
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Unlocked!'),
              actions: [
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    throw Error();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Open up, Sesame!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              'https://poapper.com/img/ogimg.png',
              // height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            IconButton(
              iconSize: 80,
              onPressed: () => onUnlock(context),
              icon: const Icon(
                Icons.lock_open,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

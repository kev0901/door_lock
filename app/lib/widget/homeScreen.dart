import 'package:app/type/keycloak_token.dart';
import 'package:app/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  final keycloak_token token;
  const HomeScreen({
    super.key,
    required this.token,
  });
  final String user_auth_address = 'http://127.0.0.1:3001';
  Uri getUri(String cmd) {
    return Uri.parse('$user_auth_address/$cmd');
  }

  void onUnlock(BuildContext context) async {
    final response = await http.get(getUri('user_auth/unlock'));
    if (context.mounted) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Unlocked!'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(response.body),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Open up, Sesame!'),
      ),
      drawer: HomeScreenDrawer(
        token: token,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // AdviceCard(),
            const SizedBox(
              height: 140,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Unlock!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            IconButton(
              iconSize: 180,
              onPressed: () => onUnlock(context),
              icon: const Icon(
                Icons.lock_open,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('Instructions'),
            const SizedBox(
              height: 15,
            ),
            const Text(
              '1. Unlock button will be activated only when\napp is connected with Poapper Wi-Fi.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              '2. Feel free to connect Poapper\nif any trouble occurs.',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/posik.png',
                        height: 160,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

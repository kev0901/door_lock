import 'package:app/type/keycloak_token.dart';
import 'package:app/value/value.dart';
import 'package:app/widget/drawer.dart';
import 'package:app/widget/showDialogCollections.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final keycloak_token token;
  const HomeScreen({
    super.key,
    required this.token,
  });

  void onUnlock(BuildContext context) async {
    showLoadingDialog(context);
    final response =
        await postToBackendServerWithAuth('user_auth/unlock', token, {});
    if (context.mounted) {
      endLoadingDialog(context);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        showTextDialog(context, 'Unlocked!');
        return;
      }
      showTextDialog(context, response.body);
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

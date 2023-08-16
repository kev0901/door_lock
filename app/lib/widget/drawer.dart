import 'package:app/type/keycloak_token.dart';
import 'package:app/widget/homeScreen.dart';
import 'package:app/widget/userAdminPage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreenDrawer extends StatelessWidget {
  final keycloak_token token;

  const HomeScreenDrawer({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final decodedToken = JwtDecoder.decode(token.access_token);
    String email = decodedToken['email'] ?? '';
    String fullName = decodedToken['name'] ?? '';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xff764abc)),
            accountName: Text(
              fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            currentAccountPicture: const FlutterLogo(),
          ),
          ListTile(
            leading: const Icon(
              Icons.lock_open,
            ),
            title: const Text('Unlock'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    token: token,
                  ),
                ),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.manage_accounts_outlined,
            ),
            title: const Text('User management'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => UserAdminPage(
                    token: token,
                  ),
                ),
                (route) => false,
              );
            },
          ),
          const AboutListTile(
            // <-- SEE HERE
            icon: Icon(
              Icons.info,
            ),
            applicationIcon: Icon(
              Icons.local_play,
            ),
            applicationName: 'Poapper Door-Lock',
            applicationVersion: '1.0.0',
            applicationLegalese: '© Poapper Inc.',
            aboutBoxChildren: [
              ///Content goes here...
            ],
            child: Text('About app'),
          ),
        ],
      ),
    );
  }
}

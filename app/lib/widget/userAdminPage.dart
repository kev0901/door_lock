import 'package:app/type/keycloak_token.dart';
import 'package:app/widget/drawer.dart';
import 'package:app/widget/passwordInput.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserAdminPage extends StatefulWidget {
  final keycloak_token token;
  const UserAdminPage({
    super.key,
    required this.token,
  });

  @override
  State<UserAdminPage> createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {
  bool curPwVisible = false;

  bool newPwVisible = false;

  bool newPwConfirmVisible = false;

  final currentPwTextController = TextEditingController();

  final newPwTextController = TextEditingController();

  final newPwConfirmTextController = TextEditingController();

  void toggleCurVisible() {
    setState(() {
      curPwVisible = !curPwVisible;
    });
  }

  void toggleNewVisible() {
    setState(() {
      newPwVisible = !newPwVisible;
    });
  }

  void toggleNewConfirmVisible() {
    setState(() {
      newPwConfirmVisible = !newPwConfirmVisible;
    });
  }

  void clickCur() {
    setState(() {
      curPwVisible = !curPwVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Open up, Sesame!'),
      ),
      drawer: HomeScreenDrawer(
        token: widget.token,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          PasswordInput(
            controller: currentPwTextController,
            onPressed: toggleCurVisible,
            passwordVisible: curPwVisible,
            labelText: 'Current Password',
          ),
          const SizedBox(
            height: 20,
          ),
          PasswordInput(
            controller: newPwTextController,
            onPressed: toggleNewVisible,
            passwordVisible: newPwVisible,
            labelText: 'New Password',
          ),
          const SizedBox(
            height: 20,
          ),
          PasswordInput(
            controller: newPwConfirmTextController,
            onPressed: toggleNewConfirmVisible,
            passwordVisible: newPwConfirmVisible,
            labelText: 'New Password Confirmation',
          ),
        ],
      ),
    );
  }
}

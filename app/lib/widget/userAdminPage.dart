import 'dart:convert';

import 'package:app/type/keycloak_token.dart';
import 'package:app/value/value.dart';
import 'package:app/widget/drawer.dart';
import 'package:app/widget/passwordInput.dart';
import 'package:app/widget/showDialogCollections.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserAdminPage extends StatefulWidget {
  late keycloak_token token;
  UserAdminPage({
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

  String username = '';

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

  Future<bool> tryGetNewTokenAndReturnSuccessOrNot() async {
    String curPw = currentPwTextController.text;
    String usernameFromToken =
        JwtDecoder.decode(widget.token.access_token)['preferred_username'];
    showLoadingDialog(context);
    final tokenResponse =
        await getTokenWithUsernameAndPw(usernameFromToken, curPw);
    if (context.mounted) {
      endLoadingDialog(context);
      if (!(tokenResponse.statusCode >= 200 &&
          tokenResponse.statusCode < 300)) {
        showTextDialog(context, 'tryGetNewToken, ${tokenResponse.body}');
        return false;
      }
    }
    keycloak_token newAccessToken =
        keycloak_token.fromJson(jsonDecode(tokenResponse.body));
    setState(() {
      widget.token = newAccessToken;
      username = usernameFromToken;
    });
    return true;
  }

  void tryPasswordChange() async {
    bool gotToken = await tryGetNewTokenAndReturnSuccessOrNot();
    if (!gotToken) return;

    String newPw = newPwTextController.text;
    String newPwConfirm = newPwConfirmTextController.text;

    bool isNewPwValid = true;
    isNewPwValid = isNewPwValid && (newPw == newPwConfirm);
    isNewPwValid = isNewPwValid && newPw.isNotEmpty;
    isNewPwValid = isNewPwValid && (newPw.length >= 8);

    if (context.mounted) {
      if (!isNewPwValid) {
        showTextDialog(context, 'Please check new PW');
        return;
      }

      showLoadingDialog(context);
      final pwChangeResponse = await postToBackendServerWithAuth(
        'user_auth/change_password',
        widget.token,
        {
          'username': username,
          'password': newPw,
        },
      );

      if (context.mounted) {
        endLoadingDialog(context);
        if (pwChangeResponse.statusCode >= 200 &&
            pwChangeResponse.statusCode < 300) {
          showTextDialog(context, 'Changed!');
          setState(() {
            currentPwTextController.text = '';
            newPwTextController.text = '';
            newPwConfirmTextController.text = '';
          });
          return;
        }
        showTextDialog(context, 'PwChangeResponse, ${pwChangeResponse.body}');
      }
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
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: tryPasswordChange,
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
}

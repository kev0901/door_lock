import 'dart:convert';

import 'package:app/type/keycloak_token.dart';
import 'package:app/value/value.dart';
import 'package:app/widget/drawer.dart';
import 'package:app/widget/loginField.dart';
import 'package:app/widget/passwordInput.dart';
import 'package:app/widget/showDialogCollections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPageListTitle extends StatelessWidget {
  final String title;
  const AdminPageListTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AdminPageListButton extends StatelessWidget {
  late void Function() onPressed;
  late Color buttonColor;
  late Color titleColor;
  late String buttonText;
  AdminPageListButton({
    super.key,
    required this.buttonColor,
    required this.onPressed,
    required this.titleColor,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(buttonColor),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: titleColor),
          ),
        ),
        const SizedBox(
          width: 30,
        )
      ],
    );
  }
}

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

  bool cur2PwVisible = false;

  final currentPwTextController = TextEditingController();

  final newPwTextController = TextEditingController();

  final newPwConfirmTextController = TextEditingController();

  final currentPwTextController2 = TextEditingController();

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

  void toggleCur2Visible() {
    setState(() {
      cur2PwVisible = !cur2PwVisible;
    });
  }

  Future<bool> tryGetNewTokenAndReturnSuccessOrNot(String curPw) async {
    String usernameFromToken =
        JwtDecoder.decode(widget.token.access_token)['preferred_username'];
    showLoadingDialog(context);
    final tokenResponse =
        await getTokenWithUsernameAndPw(usernameFromToken, curPw);
    if (context.mounted) {
      endLoadingDialog(context);
      if (!(tokenResponse.statusCode >= 200 &&
          tokenResponse.statusCode < 300)) {
        if (tokenResponse.statusCode == 401) {
          showTextDialog(context, 'Please check your current password.');
        } else {
          showTextDialog(context,
              'tryGetNewToken, ${tokenResponse.statusCode}, ${tokenResponse.body}');
        }
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
    bool gotToken =
        await tryGetNewTokenAndReturnSuccessOrNot(currentPwTextController.text);
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
          }); // todo: change to restart the page?
          return;
        }
        showTextDialog(context, 'PwChangeResponse, ${pwChangeResponse.body}');
      }
    }
  }

  NavigateToLoginScreen() {
    // todo: see whether we can change scroll motion direction
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return LoginField();
      },
    ), (route) => false);
  }

  Future<void> AskLogout(BuildContext context) async {
    await showWarningDialog(
      context,
      'Are you sure you want to logout?',
      tryLogout,
    );
  }

  Future<void> deletePrefAndSecureStorage() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    const secureStorage = FlutterSecureStorage();

    await pref.setBool('rememberMe', false);
    await secureStorage.write(
      key: 'credentials',
      value: '',
    );
  }

  void tryLogout() async {
    await deletePrefAndSecureStorage();

    NavigateToLoginScreen();
    if (context.mounted) {
      showTextDialog(context, 'Successfully logged out from this device.');
    }
  }

  void AskDelete(BuildContext context) {
    showWarningDialog(
      context,
      'Are you sure you want to delete your account?\nThis action is irreversible.',
      TryDelete,
    );
  }

  void TryDelete() async {
    bool gotToken = await tryGetNewTokenAndReturnSuccessOrNot(
        currentPwTextController2.text);
    if (!gotToken) return;

    String userId = JwtDecoder.decode(widget.token.access_token)['sub'];

    if (context.mounted) {
      showLoadingDialog(context);
      final userDeleteResponse = await postToBackendServerWithAuth(
        'user_auth/delete_account',
        widget.token,
        {
          'userId': userId,
        },
      );

      if (context.mounted) {
        endLoadingDialog(context);
        if (userDeleteResponse.statusCode >= 200 &&
            userDeleteResponse.statusCode < 300) {
          await deletePrefAndSecureStorage();
          NavigateToLoginScreen();
          showTextDialog(context, 'Successfully deleted your account.');
          return;
        }
        showTextDialog(
          context,
          'userDeleteResponse, ${userDeleteResponse.body}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Account Management'),
      ),
      drawer: HomeScreenDrawer(
        token: widget.token,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const AdminPageListTitle(title: 'Change Password'),
            const SizedBox(
              height: 40,
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
            AdminPageListButton(
              buttonColor: Colors.blueAccent,
              onPressed: tryPasswordChange,
              titleColor: Colors.white,
              buttonText: 'Change Password',
            ),
            const SizedBox(
              height: 40,
            ),
            const AdminPageListTitle(title: 'Logout from this device'),
            AdminPageListButton(
              buttonColor: Colors.blueAccent,
              onPressed: () async {
                await AskLogout(context);
              },
              titleColor: Colors.white,
              buttonText: 'Logout',
            ),
            const SizedBox(
              height: 40,
            ),
            const AdminPageListTitle(title: 'Delete Your Account'),
            const SizedBox(
              height: 10,
            ),
            PasswordInput(
              controller: currentPwTextController2,
              onPressed: toggleCur2Visible,
              passwordVisible: cur2PwVisible,
              labelText: 'Type Current Password to delete your account',
            ),
            const SizedBox(
              height: 10,
            ),
            AdminPageListButton(
              buttonColor: Colors.redAccent,
              onPressed: () {
                AskDelete(context);
              },
              titleColor: Colors.white,
              buttonText: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}

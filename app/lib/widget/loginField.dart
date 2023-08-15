import 'dart:convert';
import 'package:app/type/keycloak_token.dart';
import 'package:app/value/value.dart';
import 'package:app/widget/passwordInput.dart';
import 'package:app/widget/showDialogCollections.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/homeScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginField extends StatefulWidget {
  const LoginField({super.key});

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  late bool passwordVisible;

  final idTextController = TextEditingController();
  final pwTextController = TextEditingController();

  bool rememberMe = false; // todo: this is got from sharedPreference
  late keycloak_token token;

  static final secureStorage = FlutterSecureStorage();

  void getRememberMeAndTryLogin(BuildContext context) async {
    showLoadingDialog(context);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final prefRememberMe = pref.getBool('rememberMe');
    String id = '';
    String pw = '';
    if (prefRememberMe == true) {
      String credentials = await secureStorage.read(key: 'credentials') ?? '';
      if (credentials.isNotEmpty) {
        id = credentials.split(' ')[0];
        pw = credentials.split(' ')[1];
      }
    }
    setState(() {
      rememberMe = prefRememberMe ?? false;
      idTextController.text = id;
      pwTextController.text = pw;
    });
    if (context.mounted) {
      endLoadingDialog(context);
      if (rememberMe) tryLogin(context);
    }
  }

  @override
  void initState() {
    passwordVisible = false;
    new Future.delayed(Duration.zero, () {
      getRememberMeAndTryLogin(context);
    });
    super.initState();
  }

  void navigateToHomeScreen(keycloak_token token) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return HomeScreen(
          token: token,
        );
      },
    ), (route) => false);
  }

  void tryLogin(BuildContext context) async {
    // Navigator.of(context).push(/*waiting dialog */); <= 이건 위에 모션같은거 띄울때 쓰자.
    showLoadingDialog(context);
    final response = await getTokenWithUsernameAndPw(
        idTextController.text, pwTextController.text);
    if (context.mounted) {
      endLoadingDialog(context);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);
        token = keycloak_token.fromJson(responseBody);

        if (rememberMe) {
          final SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setBool('rememberMe', true);
          await secureStorage.write(
            key: 'credentials',
            value: '${idTextController.text} ${pwTextController.text}',
          );
        }

        navigateToHomeScreen(token);
      } else {
        showTextDialog(
          context,
          'StatusCode: ${response.statusCode}\n${response.body}',
        );
      }
    }
  }

  void clickPasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void checkId() {}

  void tryRegister(Map<String, dynamic> data) async {
    showLoadingDialog(context);
    final registerResponse = await postToBackendServer('addUser', data);
    if (context.mounted) {
      endLoadingDialog(context);
      if (registerResponse.statusCode >= 200 &&
          registerResponse.statusCode < 300) {
        // final responseBody = jsonDecode(registerResponse.body);
        Navigator.pop(context);
        showTextDialog(context,
            'Registered Successfully.\nPlease notice administrator to get access granted.');
      } else {
        showTextDialog(
          context,
          'StatusCode: ${registerResponse.statusCode}\n${registerResponse.body}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text('Poapper Door-lock'),
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
            SizedBox(
              width: 350,
              child: TextField(
                controller: idTextController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PasswordInput(
              controller: pwTextController,
              onPressed: clickPasswordVisible,
              passwordVisible: passwordVisible,
              labelText: 'Password',
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Remeber me'),
                    ],
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    ),
                    onPressed: () => tryLogin(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 350,
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot my ID/PW'),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text('Are you new here?'),
            TextButton(
              onPressed: () {
                showDialogForRegister(
                  context,
                  tryRegister,
                );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}

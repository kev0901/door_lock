import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widget/homeScreen.dart';

class LoginField extends StatefulWidget {
  const LoginField({super.key});

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  final String baseUrl = 'http://192.168.35.143:5050';

  late bool passwordVisible;

  final idTextController = TextEditingController();
  final pwTextController = TextEditingController();

  late bool rememberMe; // todo: this is got from sharedPreference

  @override
  void initState() {
    passwordVisible = false;
    rememberMe = false;
    super.initState();
  }

  Uri getUri(String cmd) {
    return Uri.parse('$baseUrl/$cmd');
  }

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const HomeScreen();
      },
    ), (route) => false);
  }

  void tryLogin(BuildContext context) async {
    // Navigator.of(context).push(/*waiting dialog */); <= 이건 위에 모션같은거 띄울때 쓰자.
    const command = 'realms/quickstart/protocol/openid-connect/token';
    final response = await http.post(
      getUri(command),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      // encoding: Encoding.getByName('utf-8'),
      body: {
        "username": idTextController.text,
        "grant_type": "password",
        "password": pwTextController.text,
        "realmName": "quickstart", // todo: add quickstart to real realm name
        "client_id": "test-cli", // todo: real client
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      navigateToHomeScreen();
    }
    if (context.mounted &&
        (response.statusCode < 200 || response.statusCode >= 300)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('StatusCode: ${response.statusCode}'),
            actions: [
              TextButton(
                child: Text(response.body),
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
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: !passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                controller: pwTextController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
            SizedBox(
              height: 40,
            ),
            const Text('Are you new here?'),
            TextButton(
              onPressed: () {},
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

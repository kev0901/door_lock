import 'package:flutter/material.dart';
import 'package:app/widget/passwordInput.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}

void endLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

void showTextDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
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

void showWarningDialog(
    BuildContext context, String text, Function() onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              onPressed();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogForRegister(
    BuildContext context, Function(Map<String, dynamic>) onPressed) {
  TextEditingController idTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();
  TextEditingController newPwTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Registration',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 20,
              // ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: firstNameTextController,
                  decoration: const InputDecoration(
                    labelText: 'First Name', // todo: add check id buton
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: lastNameTextController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name', // todo: add check id buton
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    labelText:
                        'POSTECH Email Address', // todo: add check id buton
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Credentials',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: idTextController,
                  decoration: const InputDecoration(
                    labelText: 'ID', // todo: add check id buton
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              NewPasswordInput(
                controller: pwTextController,
                labelText: 'Password',
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              NewPasswordInput(
                controller: newPwTextController,
                labelText: 'Confirm Password',
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Register'),
            onPressed: () {
              onPressed({
                'firstName': firstNameTextController.text,
                'lastName': lastNameTextController.text,
                'username': idTextController.text,
                'email': emailTextController.text,
                'password': pwTextController.text,
              });
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

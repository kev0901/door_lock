import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final bool passwordVisible;
  final void Function() onPressed;
  final TextEditingController controller;
  final String labelText;
  const PasswordInput({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.passwordVisible,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 350,
          child: TextField(
            obscureText: !passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  onPressed();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewPasswordInput extends StatelessWidget {
  final bool passwordVisible;
  final void Function() onPressed;
  final TextEditingController controller;
  final String labelText;
  const NewPasswordInput({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.passwordVisible,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 350,
          child: TextFormField(
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Can\'t be empty';
              }
              if (text.length < 4) {
                return 'Too short';
              }
              return null;
            },
            obscureText: !passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  onPressed();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

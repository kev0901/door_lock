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

class NewPasswordInput extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  double? width;

  NewPasswordInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.width,
  });

  @override
  State<NewPasswordInput> createState() => _NewPasswordInputState();
}

class _NewPasswordInputState extends State<NewPasswordInput> {
  bool passwordVisible = false;
  void onPressed() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.width ?? 350,
          child: TextField(
            // validator: (text) {
            //   if (text == null || text.isEmpty) {
            //     return 'Can\'t be empty';
            //   }
            //   if (text.length < 4) {
            //     return 'Too short';
            //   }
            //   return null;
            // },
            obscureText: !passwordVisible,
            enableSuggestions: false,
            autocorrect: false,
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.labelText,
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

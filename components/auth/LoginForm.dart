import 'package:flutter/material.dart';
import '../ui/Button.dart';
import '../ui/Input.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;

  const LoginForm({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Input(
          placeholder: 'Username',
          value: _usernameController.text,
          onChange: (value) => _usernameController.text = value,
        ),
        const SizedBox(height: 16),
        Input(
          placeholder: 'Password',
          value: _passwordController.text,
          onChange: (value) => _passwordController.text = value,
        ),
        const SizedBox(height: 16),
        Button(
          onPressed:
              () => widget.onLogin(
                _usernameController.text,
                _passwordController.text,
              ),
          child: const Text('Login'),
        ),
      ],
    );
  }
}

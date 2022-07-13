import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../screens/products_overview_screen.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  String? _errorMessage;

  bool _isLoading = false;

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final response = await Provider.of<Auth>(context, listen: false)
        .signUp(_email, _password);

    // final data = info as Map<String, dynamic>;

    setState(() {
      _errorMessage = response['message'];
    });

    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;

    if (isAuth) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, ProductsOverviewScreen.pageId);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading) const LinearProgressIndicator(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                _email = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Must enter an Email';
                }

                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                _password = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Must enter a password';
                }

                return null;
              },
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sign Up'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

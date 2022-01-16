import 'package:brew_crew/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:brew_crew/services/auth.dart';

class Register extends StatefulWidget {
  late final VoidCallback toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // email and password states
  String email = '';
  String password = '';

  String errorText = '';

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: widget.toggleView,
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: const Text(
                'Sign In',
                style: TextStyle(color: Colors.black),
              ))
        ],
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        title: const Text("Register"),
        elevation: 0.0,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 6
                      ? 'Password length should be at least 6'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _authService.registerWithEmail(
                            email: email, password: password);

                        if (result.runtimeType == FirebaseAuthException) {
                          if (result.message != null) {
                            setState(() {
                              errorText = result.message;
                              loading = false;
                            });
                          } else {
                            setState(() {
                              errorText = 'Unknown error!';
                              loading = false;
                            });
                          }

                        }
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  height: 14.0,
                ),
                Text(
                  errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          )),
    );
  }
}

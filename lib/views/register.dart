import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_dart/constants/routes.dart';
import '../utilities/errorDialog.dart';
import '../utilities/redirectDialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
          child: Column(
            children: [
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Enter your email here'),
                controller: _email,
              ),
              TextField(
                decoration:
                    InputDecoration(hintText: 'Enter your password here'),
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.sendEmailVerification();
                      Navigator.of(context).pushNamed(verifyRoute);
                    }
                  } on FirebaseAuthException catch (e) {
                    var error = '';

                    if (e.code == 'email-already-in-use') {
                      error = 'Email is already in use';
                    } else if (e.code == 'weak-password') {
                      error = 'Your password is too weak';
                    } else if (e.code == 'invalid-email') {
                      error = 'Please provide a valid email address';
                    }
                    await showErrorDialog(context, error);
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: Text("Register"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: Text('Already have an account? Log in here!'))
            ],
          ),
        ));
  }
}

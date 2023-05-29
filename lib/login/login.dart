import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/errormsg.dart';
import 'package:flutter_application_2/login/passwordreset.dart';
import 'package:flutter_application_2/login/text.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showregpage;
  const LoginPage({super.key, required this.showregpage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();

  final _password = TextEditingController();

  Future signin() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.brown,
            ),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _username.text.trim(),
        password: _password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 55,
              ),
              const Center(
                child: Icon(
                  Icons.lock,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'welcome back you have been missed',
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(
                height: 18,
              ),
              TextField1(
                controllers: _username,
                hint: 'Email',
                obscuretext: false,
              ),
              TextField1(
                controllers: _password,
                hint: 'Password',
                obscuretext: true,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Passwordreset();
                        }));
                      },
                      child: const Text(
                        'Forgot _password?',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: signin,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 60),
                    backgroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2,
                    )),
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member ? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showregpage,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

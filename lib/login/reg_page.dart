import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/login/text.dart';

import '../main.dart';

class Regpage extends StatefulWidget {
  final VoidCallback showloginpage;
  const Regpage({super.key, required this.showloginpage});

  @override
  State<Regpage> createState() => _RegpageState();
}

class _RegpageState extends State<Regpage> {
  final _username = TextEditingController();

  final _password = TextEditingController();
  final _confirmpassword = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _age = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    _firstname.dispose();
    _lastname.dispose();
    _age.dispose();
  }

  Future signup() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        });
    try {
      if (passwordconfirm()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _username.text.trim(),
          password: _password.text.trim(),
        );

        addUserdetails(
          _firstname.text.trim(),
          _lastname.text.trim(),
          _username.text.trim(),
          int.parse(_age.text.trim()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future addUserdetails(
      String firstname, String lastname, String email, int age) async {
    await FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.email).set({
      'first name': firstname,
      'last name': lastname,
      'email': email,
      'age': age,
    });
  }

  bool passwordconfirm() {
    if (_password.text.trim() == _confirmpassword.text.trim()) {
      return true;
    } else {
      return false;
    }
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
                height: 19,
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
                'Register below with your details',
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField1(
                controllers: _firstname,
                hint: 'Firstname',
                obscuretext: false,
              ),
              const SizedBox(
                height: 1,
              ),
              TextField1(
                controllers: _lastname,
                hint: 'Lastname',
                obscuretext: false,
              ),
              const SizedBox(
                height: 1,
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
                height: 1,
              ),
              TextField1(
                controllers: _confirmpassword,
                hint: 'Confrim password',
                obscuretext: true,
              ),
              const SizedBox(
                height: 1,
              ),
              TextField1(
                controllers: _age,
                hint: 'Age',
                obscuretext: false,
              ),
              const SizedBox(
                height: 1,
              ),
              ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(350, 60),
                    backgroundColor: Colors.black,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 2,
                    )),
                child: const Text('sign up'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'i am a member ? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showloginpage,
                    child: const Text(
                      'login now',
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/home1.dart';
import 'package:flutter_application_2/login/login.dart';
import 'package:flutter_application_2/login/main2.dart';

class Screenmain extends StatelessWidget {
  const Screenmain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasError) {
            return (const Center(
              child: Text("Something went wrong !"),
            ));
          } else if (snapshot.hasData) {
            return const HomeScreen1();
          } else {
            return const Authpage();
          }
        },
      ),
    );
  }
}

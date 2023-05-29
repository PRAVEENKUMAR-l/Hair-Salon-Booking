import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/login/login.dart';
import 'package:flutter_application_2/login/reg_page.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool showloginpage = true;
  void togglescreen() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return LoginPage(showregpage: togglescreen);
    } else {
      return Regpage(showloginpage: togglescreen);
    }
  }
}

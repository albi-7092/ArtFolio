import 'package:artfolio/Home.dart';
import 'package:artfolio/Login.dart';
// import 'package:artfolio/Login.dart';
// import 'package:artfolio/register.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    goto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('images/logo.jpeg')),
    );
  }

  Future<void> goto() async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    Future.delayed(const Duration(seconds: 2, microseconds: 5), () {
      if (sv == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return Login();
        }));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return Home();
        }));
      }
    });
  }
}

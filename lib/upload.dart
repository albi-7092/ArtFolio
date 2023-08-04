import 'package:flutter/material.dart';

class upload extends StatelessWidget {
  const upload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload posts'),
        backgroundColor: Color(0xFF17203A),
      ),
      body: SafeArea(
          child: ListView(
        children: [],
      )),
    );
  }
}

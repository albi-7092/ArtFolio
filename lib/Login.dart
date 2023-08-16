// ignore_for_file: unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, use_key_in_widget_constructors, camel_case_types, prefer_typing_uninitialized_variables

// import 'package:flutter/foundation.dart';
import 'package:artfolio/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  //FirebaseAuth auth = FirebaseAuth.instance;
  String dox = '';
  var stat;
  bool load = false;

  Future<void> Login(BuildContext context) async {
    setState(() {
      load = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('USER')
          .where('email', isEqualTo: email.text)
          .get();
      if (snapshot.size > 0) {
        dox = snapshot.docs[0].id;

        print(dox);
      }
      print('doc_id:$dox');
      // ignore: unnecessary_null_comparison
      if (dox != '' || dox != null) {
        login_Save();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return Home();
        }));
      }
      setState(() {
        load = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        load = false;
      });
      if (e.code == 'user-not-found') {
        print('user not found');
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Center(child: Text('ArtFolio')),
              content: const Text(
                'user not found',
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          load = false;
        });
        print('wrong password');
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Center(child: Text('ArtFolio')),
              content: const Text(
                'wrong password',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          },
        ); //SHOW
      } else if (e.code == 'cloud_firestore/unavailable') {
        // Firestore is currently unavailable, let's retry the login after a delay.
        await Future.delayed(
            Duration(seconds: 2)); // Wait for 2 seconds before retrying.
        await Login(context);
        print('here'); // Retry the login process.
      } else {
        setState(() {
          load = false;
        });
        print('invalid email id');
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Center(child: Text('ArtFolio')),
              content: const Text(
                'Invalid Email ID',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      stat = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: SizedBox(
                          width: 450,
                          height: 250,
                          child: Image.asset("images/logo.jpeg")),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email id"),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a valid email id';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextFormField(
                        controller: password,
                        obscureText: stat,
                        decoration: InputDecoration(
                            suffixIcon: stat
                                ? IconButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          stat = false;
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.visibility_off))
                                : IconButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          stat = true;
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.visibility)),
                            prefixIcon: const Icon(Icons.security),
                            hintText: "password"),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a valid password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: SizedBox(
                        width: 360,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF17203A)),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              if (load == false) {
                                Login(context);
                              }
                            }
                          },
                          child: load == false
                              ? const Text("Login")
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          const Text("Forgot your login details?"),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Get help",
                              style: TextStyle(color: Color(0xFF17203A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 95),
          child: Row(
            children: [
              const Text("Don't have an account ?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return Register();
                      },
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFF17203A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login_Save() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString(
      'doc_id',
      dox,
    );
  }
}

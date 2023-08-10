// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_import
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ImagePicker picker = ImagePicker();

  File? fileimage;

  XFile? image;
  bool stat = true;
  TextEditingController Name = TextEditingController();
  TextEditingController user_Name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconfirm = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String doc = '';
  String downloadurl = '';
  //
  CollectionReference user01 = FirebaseFirestore.instance.collection('USER');
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile) async {
    String name_loc = user_Name.text;
    try {
      String fileName = name_loc.toString();
      Reference reference =
          storage.ref().child('profile_image/$name_loc/$fileName');
      await reference.putFile(imageFile);
      String downloaduRl = await reference.getDownloadURL();

      // Save image URL to Firestore
      //await imagesCollection.add({'url': downloadURL});
      return downloaduRl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> add_user(BuildContext context) async {
    final data = {
      'name': Name.text,
      'email': email.text,
      'user_name': user_Name.text,
      'profile_img': '',
      'arts': [],
      'about': '',
      'doc_id': '',
    };
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: passwordconfirm.text);

      downloadurl = await uploadImage(fileimage!);

      await user01.add(data).then(
        (value) {
          doc = value.id;
          print(doc);
        },
      );

      final DocumentReference document = firestore.collection('USER').doc(doc);
      //document.update({'img': downloadurl});
      document.update({'doc_id': doc, 'profile_img': downloadurl});

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
      register_save();
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: Text(
              '$e',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    print(e);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    }

    // DocumentReference documentRef = user01.doc(doc);
    // documentRef.update({'doc_id': doc});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 20),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Here to Get',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Welcomed !',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        child: ClipOval(
                          child: fileimage == null
                              ? Image.asset(
                                  'images/Unknown_person.jpg',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  fileimage!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 120, top: 110),
                        child: IconButton(
                            onPressed: () {
                              pickImage();
                            },
                            icon: const Icon(Icons.camera_alt)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 05, top: 10, right: 10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                hintText: 'Name *'),
                            controller: Name,
                            validator: (value) {
                              if (value == '') {
                                return 'This field is mandatory';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.person),
                                hintText: 'User name*'),
                            controller: user_Name,
                            validator: (value) {
                              if (value == '') {
                                return 'This field is mandatory';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'email id',
                                suffixIcon: Icon(Icons.email)),
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == '') {
                                return 'This field is mandatory';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                            obscureText: false,
                            validator: (value) {
                              if (value == '') {
                                return 'password * is mandatory';
                              } else if (value!.length < 8) {
                                return 'password should be greater than 8 letters';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.security),
                                labelText: 'password'),
                            controller: password,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: TextFormField(
                            obscureText: stat,
                            decoration: InputDecoration(
                                suffixIcon: stat == true
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            stat = false;
                                          });
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
                                        icon: const Icon(Icons.visibility),
                                      ),
                                labelText: 'Re-type password'),
                            controller: passwordconfirm,
                            validator: (value) {
                              if (value == '') {
                                return 'password * is mandatory';
                              } else if (value!.length < 8) {
                                return 'password should be greater than 8 letters';
                              } else {
                                if (value != password.text) {
                                  return 'password * should be same';
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: SizedBox(
                            width: 360,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF17203A)),
                              onPressed: () {
                                if (_formkey.currentState!.validate() &&
                                    image != null) {
                                  add_user(context);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title: const Center(
                                            child: Text('ArtFolio')),
                                        content: const Text(
                                          'Image is Requiered for Registration Purpose',
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
                                }
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Already Registered ?'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (ctx) {
                  return Login();
                },
              ),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(color: Color(0xFF17203A)),
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          fileimage = File(image!.path);
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> register_save() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString(
      'doc_id',
      doc,
    );
  }
}

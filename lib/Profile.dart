// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name_field = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController about = TextEditingController();

  final ImagePicker picker = ImagePicker();
  String document_id = '';
  File? fileimage;
  XFile? image;
  String name = '';
  String profile_img = '';
  String UserName = '';
  String Email_ID = '';
  String About = '';
  String newurl = '';

  @override
  void initState() {
    // TODO: implement initState
    loaddata();
    super.initState();
  }

  Future<void> updatedata() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      document_id = sp.getString('doc_id')!;
      final DocumentReference document =
          firestore.collection('USER').doc(document_id);
      if (name_field.text != '') {
        document.update({
          'name': name_field.text,
        });
      }
      if (username.text != '') {
        document.update({
          'user_name': username.text,
        });
      }
      if (about.text != '') {
        document.update({
          'about': about.text,
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('ArtFolio')),
            content: Text(
              '$e',
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

  Future<void> loaddata() async {
    final sp = await SharedPreferences.getInstance();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    document_id = sp.getString('doc_id')!;
    firestore.collection('USER').doc(document_id).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            name = documentSnapshot.get('name');
            profile_img = documentSnapshot.get('profile_img');
            UserName = documentSnapshot.get('user_name');
            Email_ID = documentSnapshot.get('email');
            About = documentSnapshot.get('about');
            print('name :$name');
          });
        }
      },
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

  Future<void> updateImageInFirebaseStorage() async {
    String name_loc = UserName.toString();
    if (fileimage != null) {
      String fileName = name_loc.toString();
      try {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_image/$UserName/$fileName');
        UploadTask uploadTask = storageReference.putFile(fileimage!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          newurl = downloadUrl;
        });

        print("Image updated successfully. New Download URL: $newurl");
        if (newurl.isNotEmpty) {
          update();
        }
      } catch (e) {
        print("Error updating image in Firebase Storage: $e");
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Center(child: Text('Auto Hire')),
              content: Text(
                '$e',
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

  Future<void> update() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      document_id = sp.getString('doc_id')!;
      final DocumentReference document =
          firestore.collection('USER').doc(document_id);
      document.update({'profile_img': newurl});
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('ArtFolio')),
            content: Text(
              '$e',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF17203A),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        child: ClipOval(
                          child: profile_img == ''
                              ? Image.asset(
                                  'images/Unknown_person.jpg',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : fileimage == null
                                  ? Image.network(
                                      profile_img,
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
                  Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(Email_ID)
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Update Profile Details..',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: name_field,
                          decoration: InputDecoration(
                            label: Text('Name'),
                            hintText: name,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: username,
                          decoration: InputDecoration(
                            label: Text('User Name'),
                            hintText: UserName,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: TextFormField(
                          controller: about,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('About'),
                              hintText: About,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 40.0)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 360,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF17203A),
                              ),
                              onPressed: () {
                                if (fileimage != null) {
                                  updateImageInFirebaseStorage();
                                }
                                updatedata();
                                Navigator.of(context).pop();
                              },
                              child: const Text('update'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, left: 130),
          child: Text('Powered by ArtFolio'),
        ),
      ),
    );
  }
}

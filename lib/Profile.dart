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
  final FirebaseStorage storage = FirebaseStorage.instance;
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
  bool controller = false;

  @override
  void initState() {
    // TODO: implement initState
    loaddata();
    super.initState();
  }

  Future<void> updatedata() async {
    setState(() {
      controller = true;
    });
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
      if (fileimage != null) {
        String downloadurl = await uploadImage(fileimage!);
        print(downloadurl);
        if (downloadurl.isNotEmpty) {
          document.update({
            'profile_img': downloadurl,
          });
        }
      }
      setState(() {
        controller = false;
      });
    } catch (e) {
      setState(() {
        controller = false;
      });
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
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          fileimage = File(image!.path);
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String name_loc = name;
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
                      profile_img == '' && fileimage == null
                          ? CircleAvatar(
                              radius: 75,
                              backgroundImage:
                                  AssetImage('images/Unknown_person.jpg'),
                            )
                          : fileimage != null
                              ? CircleAvatar(
                                  radius: 75,
                                  backgroundImage: FileImage(fileimage!),
                                )
                              : CircleAvatar(
                                  radius: 75,
                                  backgroundImage: NetworkImage(profile_img),
                                ),
                      Padding(
                        padding: const EdgeInsets.only(left: 120, top: 110),
                        child: IconButton(
                            onPressed: () {
                              pickImage();
                            },
                            icon: const Icon(Icons.edit)),
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
                                updatedata();
                              },
                              child: controller == false
                                  ? Text('update')
                                  : CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
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

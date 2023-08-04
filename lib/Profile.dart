// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker picker = ImagePicker();

  File? fileimage;

  XFile? image;

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
                  Column(
                    children: [
                      Text(
                        'Mammotty',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text('mammotty123@gmail.com')
                    ],
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextButton(
              //     onPressed: () {},
              //     child: const Text(
              //       'Edit picture',
              //       style: TextStyle(color: const Color(0xFF17203A)),
              //     ),
              //   ),
              // ),
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
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'email id',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'user name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'About',
                          ),
                        ),
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
                              onPressed: () {},
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
}

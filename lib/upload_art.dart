import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

String document_id = '';
String name = '';
List values = [];

class upload_art extends StatefulWidget {
  const upload_art({super.key});

  @override
  State<upload_art> createState() => _upload_artState();
}

class _upload_artState extends State<upload_art> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController descriptor = TextEditingController();
  TextEditingController amount = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? fileimage;
  XFile? image;
  final _formkey = GlobalKey<FormState>();
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

  @override
  void initState() {
    // TODO: implement initState
    loaddata();
    super.initState();
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
          });
        }
      },
    );
  }

  Future<void> update() async {
    try {
      // Upload the image and get the URL
      String imageUrl = await uploadImage(fileimage!);

      // Get the value from the TextEditingController
      String descriptorText = descriptor.text;

      final sp = await SharedPreferences.getInstance();
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      document_id = sp.getString('doc_id')!;
      final DocumentReference document =
          firestore.collection('USER').doc(document_id);

      // Add new values to the 'arts' array
      document.update(
        {
          'arts': FieldValue.arrayUnion(
            [
              {
                'url': imageUrl,
                'descriptor': descriptorText,
                'amount': amount.text
              }
            ],
          ),
        },
      );

      Navigator.of(context).pop();

      // Update other fields if needed
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('ArtFolio')),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String name_loc = name;
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          storage.ref().child('published_arts/$name_loc/$fileName');
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
        title: Text('upload your Art'),
        backgroundColor: Color(0xFF17203A),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            fileimage == null
                ? Padding(
                    padding: const EdgeInsets.only(top: 170),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Drop your images here or browse',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              pickImage();
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Color(0xFF17203A),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            height: 350,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(fileimage!))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value == '') {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              controller: descriptor,
                              decoration: const InputDecoration(
                                  hintText: 'Describe your Art ..'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: amount,
                              decoration: InputDecoration(hintText: 'amount'),
                              validator: (value) {
                                if (value == '') {
                                  return 'Field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF17203A),
                                  ),
                                  child: const Text('Discard'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formkey.currentState!.validate() &&
                                        fileimage != null) {
                                      update();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF17203A),
                                  ),
                                  child: const Text('post'),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 130, bottom: 10),
            child: Text('powered by ArtFolio'),
          )),
    );
  }
}

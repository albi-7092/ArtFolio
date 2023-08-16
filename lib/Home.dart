import 'package:artfolio/Profile.dart';
import 'package:artfolio/refmodel.dart';
import 'package:artfolio/upload_art.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

String profile_img = '';
String about = '';
List<dynamic> artsArray = [];
List<dynamic> savedArray = [];

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final PageController controller =
      PageController(initialPage: 0, keepPage: true);

  int selected_index = 0;
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
            about = documentSnapshot.get('about');
            artsArray = documentSnapshot.get('arts');
            savedArray = documentSnapshot.get('saved');
            // print('name :$name');
            // print('Array:$artsArray');
          });
          // String desc = '';
          // int length = artsArray.length;
          // for (int i = 0; i < length; i++) {
          //   desc = artsArray[i]['descriptor'];
          //   print('Description :$desc');
          // }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    loaddata();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: const Text('ArtFolio'),
        actions: [
          InkWell(
            child: Column(
              children: [
                profile_img == ''
                    ? const CircleAvatar(
                        backgroundImage:
                            AssetImage('images/Unknown_person.jpg'))
                    : CircleAvatar(backgroundImage: NetworkImage(profile_img)),
              ],
            ),
            onTap: () {
              setState(() {
                selected_index = 1;
              });
              controller.animateToPage(
                selected_index,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          )
        ],
      ),
      body: PageView(
        controller: controller,
        children: [
          Container(color: Colors.white, child: page0()),
          Container(color: Colors.white, child: page1()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return upload_art();
          }));
        },
        backgroundColor: Color(0xFF17203A),
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<void> updatesaved(BuildContext ctx, image_url, String description,
    String userprofile_url, String amount) async {
  try {
    final sp = await SharedPreferences.getInstance();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    document_id = sp.getString('doc_id')!;
    final DocumentReference document =
        firestore.collection('USER').doc(document_id);

    // Add new values to the 'arts' array
    document.update(
      {
        'saved': FieldValue.arrayUnion(
          [
            {
              'url': image_url,
              'descriptor': description,
              'user_profile_url': userprofile_url,
              'amount': amount,
            }
          ],
        ),
      },
    );

    // Update other fields if needed
  } catch (e) {
    showDialog(
      context: ctx,
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

class page0 extends StatefulWidget {
  @override
  State<page0> createState() => _page0State();
}

class _page0State extends State<page0> {
  bid(BuildContext context, String x) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Center(child: Text('ArtFolio')),
          content: Text("current bid =$x"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('USER').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot userSnap = snapshot.data.docs[index];
              String userProfileUrl = userSnap['profile_img'];
              String publisherNamed = userSnap['name'];
              List<dynamic> artsArray = userSnap['arts'];

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: artsArray.length,
                    itemBuilder: (context, index) {
                      String artImageUrl = artsArray[index]['url'];
                      String artDescription = artsArray[index]['descriptor'];
                      String amount = artsArray[index]['amount'];

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // color: Colors.amber,
                          width: 500,
                          height: 620,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userProfileUrl),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        publisherNamed,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 410,
                                width: 350,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(artImageUrl),
                                  ),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          LikeButton(),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.comment)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.share)),
                                          IconButton(
                                            onPressed: () {
                                              print(artImageUrl);
                                              //call on there
                                              updatesaved(
                                                  context,
                                                  artImageUrl,
                                                  artDescription,
                                                  userProfileUrl,
                                                  amount);
                                            },
                                            icon: Icon(Icons.bookmark),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                bid(context,
                                                    artsArray[index]['amount']);
                                              },
                                              child: Text(amount))
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(userProfileUrl),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            artDescription,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs you want
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              profile_img == ''
                  ? CircleAvatar(
                      radius: 90,
                      backgroundImage: AssetImage('images/Unknown_person.jpg'))
                  : CircleAvatar(
                      radius: 90, backgroundImage: NetworkImage(profile_img)),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(about),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return Profile();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF17203A)),
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    logout();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => Login()),
                        (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF17203A)),
                  child: const Text('Log out'),
                ),
              ],
            ),
          ),
          const Divider(),
          const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.image,
                  color: Color(0xFF17203A),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.book,
                  color: Color(0xFF17203A),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 300,
                    child: artsArray.isEmpty
                        ? ListView(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 120, right: 30, top: 120),
                                child: Text("Upload your memmory.."),
                              ),
                            ],
                          )
                        : ListView.separated(
                            itemBuilder: (ctx, index) {
                              String imageUrl = artsArray[index]['url'];
                              String descriptor =
                                  artsArray[index]['descriptor'];
                              return Column(
                                children: [
                                  Container(
                                    height: 500,
                                    width: 500,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(imageUrl),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(profile_img),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            descriptor,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: artsArray.length,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: savedArray.isEmpty
                      ? const Center(child: Text('you have not saved any arts'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            mainAxisSpacing: 10.0, // Spacing between rows
                            crossAxisSpacing: 10.0, // Spacing between columns
                          ),
                          itemCount:
                              savedArray.length, // Number of items in the grid
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Stack(
                                children: [
                                  Container(
                                    //color: Colors.blue,
                                    child:
                                        Image.network(savedArray[index]['url']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 140),
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xFF17203A),
                                      backgroundImage: NetworkImage(
                                        savedArray[index]['user_profile_url'],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                // print(savedArray[index]['descriptor']);
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext) {
                                  return refmodel(
                                      savedArray[index]['url'],
                                      savedArray[index]['user_profile_url'],
                                      savedArray[index]['descriptor']);
                                }));
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    //await auth.signOut();
    final sh = await SharedPreferences.getInstance();
    await sh.clear();
  }
}

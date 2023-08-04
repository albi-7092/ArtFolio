import 'package:artfolio/Profile.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController controller =
      PageController(initialPage: 0, keepPage: true);

  int selected_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: const Text('ArtFolio'),
        actions: [
          InkWell(
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://pbs.twimg.com/profile_images/1649088268355653634/yRnzTnJg_400x400.jpg'),
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
    );
  }
}

class page0 extends StatefulWidget {
  @override
  State<page0> createState() => _page0State();
}

class _page0State extends State<page0> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://c.ndtvimg.com/2023-06/pca0th08_-prithviraj_625x300_27_June_23.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Prithviraj Sukumaran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 300,
            child: Image.network(
                'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202301/prithviraj_suriya_jyotika-one_one.jpg?VersionId=XmLflQICpgQofNi0W.9iRO1DEQ2KCkuk'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              LikeButton(
                size: 30,
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 30,
                  );
                },
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.message)),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(
                    'https://pbs.twimg.com/profile_images/1649088268355653634/yRnzTnJg_400x400.jpg'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Everyone has ups and downs. ...'),
              )
            ],
          ),
        ),
      ],
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
          const CircleAvatar(
            radius: 90,
            backgroundImage: NetworkImage(
              'https://pbs.twimg.com/profile_images/1649088268355653634/yRnzTnJg_400x400.jpg',
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Mammotty',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "“Just one small positive thought in the morning can change your whole day.” — ..."),
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
                Icons.add_a_photo,
                color: Color(0xFF17203A),
              )),
              Tab(
                  icon: Icon(
                Icons.save,
                color: Color(0xFF17203A),
              )),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Container(
                  width: 200,
                  height: 300,
                  child: ListView(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 120, right: 30, top: 120),
                        child: Text("you have not posted any arts!"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 300,
                    child: ListView(
                      children: const [
                        Image(
                          image: NetworkImage(
                            'https://c.ndtvimg.com/2023-06/pca0th08_-prithviraj_625x300_27_June_23.jpg',
                          ),
                        ),
                        Divider(),
                        Image(
                          image: NetworkImage(
                            'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202301/prithviraj_suriya_jyotika-one_one.jpg?VersionId=XmLflQICpgQofNi0W.9iRO1DEQ2KCkuk',
                          ),
                        )
                      ],
                    ), // Replace this with your content
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

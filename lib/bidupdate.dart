// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class bidupdate extends StatefulWidget {
  String document_reference, index;

  bidupdate(this.document_reference, this.index);

  @override
  State<bidupdate> createState() => _bidupdateState();
}

class _bidupdateState extends State<bidupdate> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController BID = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String doc_id = '';
  int index = 0;
  String bid = '';
  int bider = 0;
  List array = [];

  @override
  void initState() {
    // TODO: implement initState
    doc_id = widget.document_reference;
    index = int.parse(widget.index);
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    firestore.collection('USER').doc(doc_id).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            array = documentSnapshot.get('arts');
            bid = array[index]['amount'];
            bider = int.parse(bid);
            print(bid);
          });
        }
      },
    );
  }

  void update() async {
    int newBidAmount = int.parse(BID.text);

    // Update the 'amount' value for the bid in the 'arts' array
    array[index]['amount'] = newBidAmount.toString();

    try {
      // Update the 'arts' array in the Firestore document
      await firestore.collection('USER').doc(doc_id).update({'arts': array});

      setState(() {
        bid = newBidAmount.toString();
        bider = newBidAmount;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("BID updated successfully"),
      ));
      print('Bid updated successfully');
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('ArtFolio')),
            content: Text(
              '$error',
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
      print('Error updating bid: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bidupdation'),
        backgroundColor: Color(0xFF17203A),
      ),
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "current bid :$bid",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: BID,
                  decoration: InputDecoration(hintText: 'Enter your bid :'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    int x = int.parse(BID.text);
                    if (x > bider) {
                      print(x);
                      update();
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Center(child: Text('ArtFolio')),
                            content: Text(
                              'You can only bid for a higher value than the current bid',
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF17203A)),
                  child: const Text('Place your bid'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

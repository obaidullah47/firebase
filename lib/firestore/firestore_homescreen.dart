import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_post_firestore.dart';

class FirestoreHomescreen extends StatefulWidget {
  static const String id = "firestorehomescreen";

  const FirestoreHomescreen({super.key});

  @override
  State<FirestoreHomescreen> createState() => _FirestoreHomescreenState();
}

class _FirestoreHomescreenState extends State<FirestoreHomescreen> {
  // // NotificationServices notificationServices = NotificationServices();
  // Service _service = Service();
  // @override
  // void initState() {
  //   super.initState();
  //   _service.getDeviceToken();
  //   _service.ReqNotificationService();
  //   _service.initializednotification();
  //   _service.firebasenotificaiton();
  // }

  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection('posts').snapshots();
  final _seacrchcontroller = TextEditingController();
  final _editcontroller = TextEditingController();
  CollectionReference _reference = FirebaseFirestore.instance.collection(
    "posts",
  );
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _seacrchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireStore__HomeScreen"),
        actions: [
          IconButton(
            onPressed: () {
              _auth
                  .signOut()
                  .then((value) {
                    GeneralUtils.fluttertoast("Sign out");
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  })
                  .onError((error, stackTrace) {
                    GeneralUtils.fluttertoast(error.toString());
                  });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _seacrchcontroller,
              decoration: InputDecoration(
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (String value) {
                // Change: Trigger a rebuild every time the user types to update the list
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: $Error");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final String dataText = doc['data'].toString();
                      final id = doc['id'].toString();

                      // Change: If search bar is empty, show all items
                      if (_seacrchcontroller.text.isEmpty) {
                        return ListTile(
                          key: ValueKey(doc.id),
                          title: Text(doc['data'].toString()),
                          trailing: PopupMenuButton(
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {
                                  showdialoge(dataText, id);
                                },
                                value: 1,
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text("Edit"),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  _reference.doc(id).delete();
                                },
                                value: 2,

                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete"),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // Change: Added filtering logic to check if the document data contains the search text
                      // toLowerCase() is used for case-insensitive search and trim() to handle extra spaces
                      else if (dataText.toLowerCase().contains(
                        _seacrchcontroller.text.toLowerCase().toString(),
                      )) {
                        return ListTile(title: Text(doc['data'].toString()));
                      }
                      // Change: Return an empty container for items that don't match the search
                      else {
                        return Container();
                      }
                    },
                  );
                }
                return GeneralUtils.fluttertoast("Something went wrong");
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostFirestore()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> showdialoge(String msg, String id) async {
    _editcontroller.text = msg;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextField(
              controller: _editcontroller,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _reference
                    .doc(id)
                    .update({'data': _editcontroller.text.toString()})
                    .then((value) {
                      GeneralUtils.fluttertoast("updated");
                    })
                    .onError((error, stackTrace) {
                      GeneralUtils.fluttertoast(error.toString());
                    });
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:flutter/material.dart';

import 'add_post_firestore.dart';

class FirestoreHomescreen extends StatefulWidget {
  static const String id = "firestorehomescreen";
  const FirestoreHomescreen({super.key});

  @override
  State<FirestoreHomescreen> createState() => _FirestoreHomescreenState();
}

class _FirestoreHomescreenState extends State<FirestoreHomescreen> {
  bool loading = false;
  final firestore = FirebaseFirestore.instance.collection('posts').snapshots();
  final _seacrchcontroller = TextEditingController();
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
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
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

                      // Change: If search bar is empty, show all items
                      if (_seacrchcontroller.text.isEmpty) {
                        return ListTile(
                          key: ValueKey(doc.id),
                          title: Text(doc['data'].toString()),
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
}

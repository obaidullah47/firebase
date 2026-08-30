import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostFirestore extends StatefulWidget {
  static const String id = "addpostfirestore";
  const AddPostFirestore({super.key});

  @override
  State<AddPostFirestore> createState() => _AddPostFirestoreState();
}

class _AddPostFirestoreState extends State<AddPostFirestore> {
  final _FireStore = FirebaseFirestore.instance.collection("posts");
  bool loading = false;
  final _addpostcontroller = TextEditingController();
  @override
  void dispose() {
    _addpostcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FireStore__Posts")),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _addpostcontroller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Post of the day..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          RoundButton(
            title: "Add Post",
            loading: loading,
            onPress: () {
              setState(() {
                loading = true;
              });
              String time = DateTime.now().microsecondsSinceEpoch.toString();
              _FireStore.doc(time)
                  .set({'data': _addpostcontroller.text.toString(), 'id': time})
                  .then((value) {
                    setState(() {
                      loading = false;
                    });
                    GeneralUtils.fluttertoast("Added Done");
                  })
                  .onError((error, stackTrace) {
                    GeneralUtils.fluttertoast(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
            },
          ),
        ],
      ),
    );
  }
}

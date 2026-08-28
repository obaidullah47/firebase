import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  static const String id = 'post_screen';
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _postcontroller = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref("Posts");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POSTS'),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            SizedBox(height: 40),
            TextFormField(
              controller: _postcontroller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Share Your Thoughts..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 40),
            RoundButton(
              title: "Add Post",
              loading: loading,
              onPress: () {
                setState(() {
                  loading = true;
                });
                databaseRef
                    .child(DateTime.now().microsecondsSinceEpoch.toString())
                    .set({
                      'id': DateTime.now().microsecondsSinceEpoch.toString(),
                      'Thoughts :': _postcontroller.text.toString(),
                    })
                    .then((value) {
                      GeneralUtils.flushbar("Post Added", context);
                      setState(() {
                        loading = false;
                      });
                    })
                    .onError((error, stackTrace) {
                      GeneralUtils.flushbar(error.toString(), context);
                      setState(() {
                        loading = false;
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

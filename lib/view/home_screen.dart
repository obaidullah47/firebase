import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/view/Posts/post_screen.dart';
import 'package:firebase/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "homescreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ref = FirebaseDatabase.instance.ref('Posts');
  final searchcontroller = TextEditingController();
  final editcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _auth
                  .signOut()
                  .then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.id,
                      (route) => false,
                    );
                    GeneralUtils.flushbar("Signed out successfully", context);
                  })
                  .onError((error, stackTrace) {
                    if (kDebugMode) {
                      print(error.toString());
                    }
                    GeneralUtils.flushbar(error.toString(), context);
                  });
            },
            icon: const Icon(Icons.login, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ],
        title: const Text("HomeScreen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
              controller: searchcontroller,
              decoration: InputDecoration(
                hintText: "Search",
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (String values) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  List<dynamic> list = [];

                  if (snapshot.data!.snapshot.value is Map) {
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    list = map.values.toList();
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final title = list[index]['Thoughts :'].toString();
                      final id = list[index]['id'].toString();
                      if (searchcontroller.text.isEmpty) {
                        return ListTile(
                          key: ValueKey(list[index]['id']),
                          title: Text(
                            list[index]['Thoughts :']?.toString() ??
                                "No Thoughts",
                          ),
                          trailing: PopupMenuButton(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            icon: Icon(Icons.more_vert_outlined),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showdialogue(context, title, id);
                                  },
                                  leading: Icon(Icons.edit),

                                  title: Text("Edit"),
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ref
                                        .child(id)
                                        .remove()
                                        .then((value) {
                                          GeneralUtils.fluttertoast("Deleted");
                                        })
                                        .onError((error, stackTrace) {
                                          GeneralUtils.fluttertoast(
                                            error.toString(),
                                          );
                                        });
                                  },
                                  leading: Icon(Icons.delete_forever),
                                  title: Text("Delete"),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (title.toLowerCase().contains(
                        searchcontroller.text.toLowerCase().toLowerCase(),
                      )) {
                        return ListTile(
                          key: ValueKey(list[index]['id']),
                          title: Text(
                            list[index]['Thoughts :']?.toString() ??
                                "No Thoughts",
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return const Center(child: Text("No posts found."));
                }
              },
            ),
          ),
          // Expanded(
          //   child: FirebaseAnimatedList(
          //     query: ref,
          //     defaultChild: const Center(child: CircularProgressIndicator()),
          //     itemBuilder: (context, snapshot, animation, child) {
          //       return ListTile(
          //         title: Text(snapshot.child('Thoughts :').value.toString()),
          //         subtitle: Text(snapshot.child("id").value.toString()),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> showdialogue(
    BuildContext context,
    String post,
    String id,
  ) async {
    editcontroller.text = post;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            child: TextField(
              controller: editcontroller,
              decoration: InputDecoration(hintText: "Edit here"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref
                    .child(id)
                    .update(({'Thoughts :': editcontroller.text.toLowerCase()}))
                    .then((value) {
                      GeneralUtils.fluttertoast("Updated");
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

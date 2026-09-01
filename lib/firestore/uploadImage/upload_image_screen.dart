import 'dart:io';

import 'package:firebase/utils/general_utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  static const String id = 'uploadimagescreen';
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref(
    'posts',
  );
  File? _image;
  final pickedfile = ImagePicker();
  Future getimage() async {
    final pickedimage = await pickedfile.pickImage(source: ImageSource.gallery);
    setState(() {});
    if (pickedimage != null) {
      _image = File(pickedimage.path);
    } else {
      return GeneralUtils.fluttertoast("No image picked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getimage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                ),
                child: _image != null
                    ? Image.file(
                        _image!.absolute,
                        fit: BoxFit.fitWidth,
                        filterQuality: FilterQuality.high,
                      )
                    : Icon(Icons.photo_album),
              ),
            ),
          ),
          SizedBox(height: 40),
          RoundButton(
            loading: loading,
            title: "Upload",

            onPress: () async {
              setState(() {
                loading = true;
              });
              final timeID = DateTime.now().microsecondsSinceEpoch.toString();
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage
                  .instance
                  .ref('/images/' + '$timeID');
              firebase_storage.UploadTask uploadTask = ref.putFile(
                _image!.absolute,
              );
              Future.value(uploadTask)
                  .then((value) async {
                    setState(() {
                      loading = true;
                    });
                    var newURL = await ref.getDownloadURL();
                    _databaseReference
                        .child('1')
                        .set({'id': timeID, 'data': newURL.toString()})
                        .then((value) {
                          setState(() {
                            loading = false;
                          });
                          GeneralUtils.fluttertoast("Upload done");
                        })
                        .onError((error, stackTrace) {
                          setState(() {
                            loading = false;
                          });
                          GeneralUtils.fluttertoast(error.toString());
                        });
                  })
                  .onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    GeneralUtils.fluttertoast(error.toString());
                  });
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class StreamingScreen extends StatefulWidget {
  @override
  _StreamingScreenState createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  // Future<void> _uploadFile(File file, String filename) async {

  //   if (fileType == 'listall') {
  //     // storageReference =
  //     // FirebaseStorage.instance.ref().child("others/$filename");
  //     FirebaseStorage.instance.ref().child("audio").listAll().then((value) {
  //       print(value);
  //     }).catchError((error) {
  //       print("error: $error");
  //     });
  //   }
  //   final StorageUploadTask uploadTask = storageReference.putFile(file);
  //   final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
  //   final String url = (await downloadUrl.ref.getDownloadURL());
  //   print("URL is $url");
  // }

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'listall') {
        FirebaseStorage.instance.ref().child("audio").listAll().then((value) {
          print(value);
          var data = value;
          var dataitems = data['items'].toList();
          var datavlues = dataitems[0];
          var name = datavlues['name'];
          print(name);
        }).catchError((error) {
          print("error: $error");
        });
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                'listall',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.image,
                color: Colors.redAccent,
              ),
              onTap: () {
                setState(() {
                  fileType = 'listall';
                });
                filePicker(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Firestorage Demo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasedemo/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class Addbakery extends StatefulWidget {
  @override
  _AddbakeryState createState() => _AddbakeryState();
}

class _AddbakeryState extends State<Addbakery> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _pricecontroller = TextEditingController();
  TextEditingController _typecontroller = TextEditingController();

  // ignore: unused_field
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    // var _bakerynamecontroller;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการเบเกอรี่'),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.brown[400],
                Colors.pink[100],
                Colors.orange[50],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        chooseImage();
                      },
                      child: Text('เลือกรูป'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 100,
              child: _image == null
                  ? Text('ไม่ได้อัพโหลดรูปภาพ')
                  : Image.file(_image),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "ชื่อเบเกอรี่",
                    filled: true,
                     fillColor: Colors.blue[50],
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),

                     
                      ),
                  controller: _namecontroller,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType:TextInputType.phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      labelText: "ราคา",
                      filled: true,
                     fillColor: Colors.blue[50],
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                      ),
                  controller: _pricecontroller,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), 
                      labelText: "ประเภท",
                      filled: true,
                     fillColor: Colors.blue[50],
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                      ),
                  controller: _typecontroller,
                ),
              ),
            ),
            RaisedButton(
              onPressed: () {
                addbakery();
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text("ต้องการบันทึกข้อมูลหรือไม่"),
                            ),
                          ],
                        ),
                        actions: [
                          FlatButton(
                              child: Text('ยกเลิก'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text('ตกลง'),
                              onPressed: () {
                                MaterialPageRoute route = MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                );
                                Addbakery();
                                Navigator.push(context, route);
                              })
                        ],
                      );
                    });
              },
              //ปุ่ม button บันทึกการแก้ไขข้อมูล
              child: Text('เพิ่มข้อมูล'),
              color: Colors.lightBlueAccent,
              textColor: Colors.white
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addbakery(
      //  String bn,
      //  String bt,
      //  int p,
      //  String i,
      ) async {
    String fileName = Path.basename(_image.path);
    StorageReference reference =
        FirebaseStorage.instance.ref().child('$fileName');
    StorageUploadTask storageUploadTask = reference.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) async {
      await FirebaseFirestore.instance.collection("Bakerys").add({
        'bakery_name': _namecontroller.text,
        'bakery_type': _typecontroller.text,
        'price': int.parse(_pricecontroller.text),
        'img': value,
      });
    });
  }

  Future<void> chooseImage() async {
    // ignore: non_constant_identifier_names
    final PickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print('ยังไม่ได้อัพโหลดรูปภาพ');
      }
    });
  }
}

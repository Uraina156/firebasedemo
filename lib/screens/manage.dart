import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Manage extends StatefulWidget {
  final String docid;
  const Manage({Key key, this.docid}) : super(key: key);

  @override
  _ManageState createState() => _ManageState();
}
class _ManageState extends State<Manage> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _pricecontroller = TextEditingController();
  TextEditingController _typecontroller = TextEditingController();
  @override
  void initState(){
     super.initState();
    getInfo();
  }
   
  Widget build(BuildContext context) {
   // var _bakerynamecontroller;
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลเบเกอรี่'),
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                        border: OutlineInputBorder(), labelText: "ประเภท",
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
               child: Text ("บันทึก"),
              onPressed: () {
              updateBakery(
              );    
            }
            ),
          

          ],
        ),
      ),
    );
  }

  Future<void> getInfo() async {
    await FirebaseFirestore.instance
        .collection("Bakerys")
        .doc(widget.docid)
        .get()
        .then((value) {
      setState(() {
      _namecontroller = TextEditingController(text: value.data()['bakery_name']);
      _pricecontroller =TextEditingController(text: value.data()['price'].toString());
      _typecontroller = TextEditingController(text: value.data()['bakery_type']);
      });
    });
  }
  Future<void> updateBakery() async{
    await FirebaseFirestore.instance
    .collection("Bakerys")
    .doc(widget.docid)
    .update({
      'bakery_name':_namecontroller.text,
      'price':int.parse(_pricecontroller.text),
      'bakery_type':_typecontroller.text,
    }).whenComplete(() => Navigator.pop(context));
  }
}

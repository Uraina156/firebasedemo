import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyW extends StatefulWidget {
  @override
  _MyWState createState() => _MyWState();
}

class _MyWState extends State<MyW> {
    bool isSearching = false; 
    String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
        backgroundColor: Colors.cyan
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
          child:Column(
            children: [
            realto(), 
            ],
          ),
         
      ),
                  
                );
              }
      
      realto() {
      return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Bakerys").where('bakery_type',isEqualTo:'เค้ก').snapshots(),
      builder: (context, snapshots) {
        switch (snapshots.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
            break;
          default:
            return Column(
              children: makeListWidget(snapshots),
                          );
                      }
                    },
                  );
                      }
              
    List<Widget> makeListWidget(AsyncSnapshot snapshots) {
    return snapshots.data.docs.map<Widget>((document) {
      return Card(
        child: ListTile(
          leading: Container(
              width: 100,
              child: Image.network(
                document['img'],
                fit: BoxFit.cover,
              )),
          title: Text(document['bakery_name']),
          subtitle: Text(document['price'].toString()),
        ),
        
      );
    }).toList();
  }
}
      
      

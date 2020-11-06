import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/add.dart';
import 'package:firebasedemo/screens/authen.dart';
import 'package:firebasedemo/screens/coo.dart';
import 'package:firebasedemo/screens/login.dart';
import 'package:firebasedemo/screens/manage.dart';
import 'package:firebasedemo/screens/pai.dart';
import 'package:firebasedemo/screens/w.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_slidable/flutter_slidable.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String user;
  String password;
  bool isSearching = false; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.login,
              color: Colors.white,
            ),
            
            
            onPressed: () => googleSignOut().whenComplete(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (route) => false);
              {
                // do something
              }
            }),
          )
          
        ],
        title: Text("Bakery"),
        backgroundColor: Colors.cyan,
      ), 
      // AppBar(
      //   title: !isSearching
      //       ? Text("Bakerys")
            
      //       : TextField(
      //         style: TextStyle(color: Colors.white),
      //         decoration: InputDecoration(
      //         icon: Icon(
      //           Icons.search,
      //           color: Colors.white,
                
      //         ),
      //         hintText: "ค้นหา",
      //         hintStyle: TextStyle(color: Colors.white)),
      //         ),
              
        // actions: <Widget>[
        //   isSearching ?
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         this.isSearching = false;
        //       });
        //     },
        //     icon: Icon(Icons.cancel),
        //   ):
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         this.isSearching = true;
        //       });
        //     },
        //     icon: Icon(Icons.search),
        //   )
          
        // ],
      //),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => Addbakery(),
            );
            Navigator.push(context, route);
              },
              child: Text("+++  เพิ่มข้อมูล  +++"),
              color: Colors.lightBlue[100],
              
            ),
            RaisedButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => MyW(),
            );
            Navigator.push(context, route);
              },
              child: Text("เค้ก"),
              color: Colors.amber[700],
            ),
            RaisedButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => MyC(),
            );
            Navigator.push(context, route);
              },
              child: Text("คุกกี้"),
              color: Colors.amber[700],
            ),
          RaisedButton(
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => MyP(),
            );
            Navigator.push(context, route);
              },
              child: Text("พาย"),
              color: Colors.amber[700],
            ),
            realTimeFood(),
            
          ],
          
        ),
        
      ),

      
    );
  }

  Widget realTimeFood() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Bakerys").snapshots(),
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
          trailing: IconButton(
              //--------trailing คือ เพิ่มข้างหลัง เพื่อไว้ใส่ icon ลบ
              icon: Icon(Icons.delete),
              color: Colors.red[300],
              //----------ปุ่มลบ-----------
              onPressed: () {
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
                              child: Text("ต้องการลบข้อมูลหรือไม่!!"),
                            )
                          ],
                        ),
                        actions: [
                          FlatButton(
                              child: Text("ลบ"),
                              color: Colors.red,
                              onPressed: () {
                                deleteFood(
                                    document.id); //-------ใส่ document id
                                Navigator.of(context).pop();
                              }),
                          FlatButton(
                              child: Text("ยกเลิก"),
                              color: Colors.blueGrey,
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    });
              }),
          leading: Container(
              width: 100,
              child: Image.network(
                document['img'],
                fit: BoxFit.cover,
              )),
          title: Text(document['bakery_name']),
          subtitle: Text(document['price'].toString()),
          onTap: () {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => Manage(docid: document.id),
            );
            Navigator.push(context, route);
          },
        ),
        
      );
    }).toList();
  }
Future<void> deleteFood(id) async {
    await FirebaseFirestore.instance.collection("Bakerys").doc(id).delete();
  }
 


}

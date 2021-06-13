import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  var count = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firestore Demo'),
        ),
        body: createListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Firestore 上にデータを追加
            FirebaseFirestore.instance.collection('characters').add({
              'name': 'タイトル$count',
              'color': '著者$count',
            });
            count += 1;
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  createListView() {
    FirebaseFirestore.instance
        .collection('characters')
        .snapshots()
        .listen((data) {
      print(data);
    });
    // gs://janken-remix.appspot.com/characters/amabie/amabie1_smile.png
    // var islandRef = storageRef.child("images/island.jpg")

// Create local filesystem URL
//     var localURL = URL(string: "path/to/image")!
//
// // Download to the local filesystem
//     var downloadTask = islandRef.write(toFile: localURL) { url, error in
//     if var error = error {
//     // Uh-oh, an error occurred!
//     } else {
//     // Local file URL for "images/island.jpg" is returned
//     }
//     }

    FirebaseFirestore.instance
        .collection('characters')
        .snapshots()
        .listen((data) {
      print(data);
    });

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // エラーの場合
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // 通信中の場合
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading ...');
          default:
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name']),
                  subtitle: new Text(document['color']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}


import 'package:belmondoproject/painting_details.dart';
import 'package:belmondoproject/send_painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference = FirebaseFirestore.instance.collection('images');

  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          // Check if data arrived
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Get the data
          QuerySnapshot querySnapshot = snapshot.data!;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;

          // Convert the documents to Maps
          List<Map> items = documents.map((e) => e.data() as Map).toList();

          return MasonryGridView.builder(
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              Map thisItem = items[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: GestureDetector(
                    onTap: () async {

                      final docID = documents.elementAt(index).id;

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => paintingDetails(docID.toString(), thisItem['image'].toString(), thisItem['name'].toString())));
                    
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(thisItem['image']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => sendPainting()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

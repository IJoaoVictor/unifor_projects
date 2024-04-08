import 'package:belmondoproject/firebase_options.dart';
import 'package:belmondoproject/painting_details.dart';
import 'package:belmondoproject/send_painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Na PaintingDetails tem o processo padrão onde os pontos são colocados manualmente
// Na Gogh (mesma coisa pro velho) tem usando banco de dados


void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: HomePage()));
  runApp(ProviderScope(child: HomePage())); // Bagulho necessário pra criar Pontos em qualquer lugar
}

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference = FirebaseFirestore.instance.collection('images');

  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Acervo da Unifor'),
              centerTitle: true,
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // Check error
                if (snapshot.hasError) {
                  return Center(child: Text('Ocorreu algum erro ${snapshot.error}'));
                }
          
                // Check if data arrived
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
          
                // Get the data
                QuerySnapshot querySnapshot = snapshot.data!;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                if (documents.isEmpty) {
                  return Center(child: Text("Não há nenhuma pintura no banco de dados"));
                }
          
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
                                builder: (context) => paintingDetails(
                                  docID.toString(), thisItem['image'].toString(), thisItem['name'].toString())));
                          
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => sendPainting()));
              },
              tooltip: 'Adicionar Pintura',
              child: const Icon(Icons.add),
            ),
          );
        }
      ),
    );
  }
}

import 'dart:developer';

import 'package:belmondoproject/auth/login.dart';
import 'package:belmondoproject/painting_details.dart';
import 'package:belmondoproject/send_painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

bool isUserAuthenticated() 
{
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser != null;
}


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver  {
  
  CollectionReference _reference = FirebaseFirestore.instance.collection('images');
  late Stream<QuerySnapshot> _stream;
  bool _isUserAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _stream = _reference.snapshots();
    _checkAuthentication();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        log("Pausado");
        break;
      case AppLifecycleState.resumed:
        log("Resumido");
        break;
      case AppLifecycleState.inactive:
        log("Inativo");
        break;
      case AppLifecycleState.detached:
        FirebaseAuth.instance.signOut();
        break;
      case AppLifecycleState.hidden:
        log("Hidden");
    }
  }

  void _checkAuthentication() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      _isUserAuthenticated = auth.currentUser != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Acervo da Unifor'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
          ),
        ),
        
        body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Ocorreu algum erro ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            if (documents.isEmpty) {
              return Center(child: Text("Não há nenhuma pintura no banco de dados"));
            }

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
        floatingActionButton: _isUserAuthenticated
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendPainting()));
                },
                tooltip: 'Adicionar Pintura',
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

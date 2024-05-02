import 'package:belmondoproject/home_page.dart';
import 'package:belmondoproject/send_video.dart';
import 'package:belmondoproject/video_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_tts/flutter_tts.dart';


FlutterTts flutterTts = FlutterTts();

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

final coordinatesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, imageName) async {
  final querySnapshot = await FirebaseFirestore.instance.collection('coordinates_$imageName').get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
});

final coordinatesNotifierProvider = StateNotifierProvider<CoordinatesNotifier, List<Map<String, dynamic>>>((ref) {
  return CoordinatesNotifier();
});

class CoordinatesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CoordinatesNotifier() : super([]);

  void addCoordinate(Offset coordinate, String information, String imageName) async {
    final collectionReference = FirebaseFirestore.instance.collection('coordinates_$imageName');
    await collectionReference.add({
      'x': coordinate.dx,
      'y': coordinate.dy,
      'information': information,
    });
    state = [...state, {'coordinate': coordinate, 'information': information}];
  }

  void removeCoordinate(int index, String imageName) async {
    
    state = List.from(state)..removeAt(index);
    
  }
}

class paintingDetails extends ConsumerWidget {
  
  paintingDetails(this.docID, this.imageURL, this.imageName, {Key? key}) : super(key: key);

  final String imageURL;
  final String imageName;
  final String docID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final AsyncValue<List<Map<String, dynamic>>> coordinatesAsync = ref.watch(coordinatesProvider(imageName));
    final TextEditingController informationController = TextEditingController();

    CollectionReference _referenceVideos = FirebaseFirestore.instance.collection('videos');

    Reference storageReferance = FirebaseStorage.instance.ref();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
          
          if (isUserAuthenticated())
          
          IconButton(onPressed: () async {
             Navigator.push(context, MaterialPageRoute(builder: (context) => SendVideo(videoName: imageName,)));           
          }, icon: Icon(Icons.add_a_photo)),

          if (isUserAuthenticated())
          IconButton(onPressed: () async {
            //Delete the item
            FirebaseFirestore.instance.collection('images').doc(docID).delete();

            //Deletando todas as coordenadas da pintura
            
            var collection = FirebaseFirestore.instance.collection('coordinates_$imageName');
            var snapshots = await collection.get();
            
            for (var doc in snapshots.docs) {
              await doc.reference.delete();}
            
            await _referenceVideos.where('name', isEqualTo: imageName).get().then((querySnapshot) {
              querySnapshot.docs.forEach((doc) async {
              final desertRefImage = storageReferance.child("images/${imageName}.jpg");
              final desertRefVideo = storageReferance.child("videos/${imageName}.mp4");
              await desertRefVideo.delete();
              await desertRefImage.delete();
              await doc.reference.delete();
              });
            });

            Navigator.pop(context);
          },
          
          icon: Icon(Icons.delete)),

        ],
          title: Text(imageName),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        floatingActionButton: FloatingActionButton // Botão de adicionar
        
          (
            onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => videoDetails(videoName: imageName,)));

          }, 
          
          child: Icon(Icons.play_arrow)
        ),
        body: coordinatesAsync.when(
          data: (coordinates) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isUserAuthenticated())
                GestureDetector(
                  onDoubleTapDown: (TapDownDetails details) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: TextField(
                          controller: informationController,
                          decoration: const InputDecoration(labelText: "Escreva a observação: "),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              ref.read(coordinatesNotifierProvider.notifier).addCoordinate(details.globalPosition, informationController.text, imageName);
                              // ignore: unused_result
                              ref.refresh(coordinatesProvider(imageName));
                              Navigator.pop(context);

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                
                                content: Text("Observação enviada!"),
                                
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Continuar"),
                                    ),
                                  ],
                                ),
                              );
                               // Fechar o diálogo após adicionar a coordenada
                              
                            },
                            child: Text("Adicionar"),
                          ),
                          
                        ],
                      ),
                    );
                  },
                ),
                ...coordinates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final coordinate = entry.value;
                  return Positioned(
                    left: coordinate['x'] -20,
                    top: coordinate['y'] -75,
                    child: GestureDetector(
                      onLongPress: () async { 
                      
                      final collectionReference = FirebaseFirestore.instance.collection('coordinates_$imageName');
                      final querySnapshots = await collectionReference.get();
                      final documentID = querySnapshots.docs.elementAt(index).id;
                      await collectionReference.doc(documentID).delete();

                      // ignore: unused_result
                      ref.refresh(coordinatesProvider(imageName));

                      showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("Observação deletada!"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Continuar"),
                                ),
                              ],
                            ),
                          );
                      
                      
                     },
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(coordinate['information']),
                              actions: [

                                IconButton(
                                onPressed: () => textToSpeech((coordinate['information'])), 
                                icon: Icon(Icons.headset)),

                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                                
                                
                                
                              ],
                            ),
                          );
                        },
                        child: Text("${index + 1}"),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final coordinatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance.collection('coordinates1').get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
});

class CoordinatesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CoordinatesNotifier() : super([]);

  void addCoordinate(Offset coordinate, String information) {
    state = [...state, {'coordinate': coordinate, 'information': information}];
  }

  void removeCoordinate(int index) {
    state = List.from(state)..removeAt(index);
    // Notifica os consumidores sobre a alteração na lista de coordenadas
  }
}

class velho extends ConsumerWidget {
  const velho({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Map<String, dynamic>>> coordinatesAsync = ref.watch(coordinatesProvider);

    final TextEditingController informationController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("O Céu de Van Gogh"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: coordinatesAsync.when(
          data: (coordinates) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage("lib/images/velhogif.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: TextField(
                          controller: informationController,
                          decoration: const InputDecoration(labelText: "Escreva a observação: "),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('coordinates1').add({
                                'x': details.globalPosition.dx,
                                'y': details.globalPosition.dy,
                                'information': informationController.text,
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Ok"),
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
                    left: coordinate['x'],
                    top: coordinate['y'],
                    child: GestureDetector(
                      onLongPress: () async {
                        var collection = FirebaseFirestore.instance.collection('coordinates1');
                        var querySnapshots = await collection.get();

                        var documentID = querySnapshots.docs.elementAt(index).id;
                        
                        await FirebaseFirestore.instance.collection('coordinates1').doc(documentID).delete();

                     
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(coordinate['information']),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("${index+1}"),
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

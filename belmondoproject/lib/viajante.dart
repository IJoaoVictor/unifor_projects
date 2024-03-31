import 'package:belmondoproject/viajante_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 70% GPT e 31% só deus sabe

final coordinatesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance.collection('coordinates2').get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
});

class CoordinatesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CoordinatesNotifier() : super([]);

  // Adiciona as coordenadas 

  void addCoordinate(Offset coordinate, String information) {
    state = [...state, {'coordinate': coordinate, 'information': information}];
  }

  // Remove as coordenadas 
  
  void removeCoordinate(int index) {
    state = List.from(state)..removeAt(index);
  }
}

class Traveller extends ConsumerWidget {
  const Traveller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final AsyncValue<List<Map<String, dynamic>>> coordinatesAsync = ref.watch(coordinatesProvider);
    final TextEditingController informationController = TextEditingController(); // onde o usuário digita a mensagem

    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
          title: const Text("O Viajante"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),


        floatingActionButton: FloatingActionButton // Botão de adicionar
        
          (
            onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const viajanteVideo()));

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
                      image: const AssetImage("lib/images/image1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // O detector de gestos capta as coordenadas do clique e utiliza pra posicionar o botão
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
                              await FirebaseFirestore.instance.collection('coordinates2').add({ // Aqui é feito o envio para o banco de dados
                                'x': details.globalPosition.dx, // Coordenada X
                                'y': details.globalPosition.dy, // Coordenada Y
                                'information': informationController.text, // Conteúdo da mensagem
                                
                              });
                              Navigator.pop(context);
                              ref.refresh(coordinatesProvider); // Atualiza a página
                             },
                            child: const Text("OK"),
                          ),
                        ],
                      ),                      
                    );
                  },
                ),
                

                // Criação dos botões
                // Cada coordenada criada é adicionada numa lista, então é criado automaticamente um botão pra cada elemento dessa lista

                ...coordinates.asMap().entries.map((entry) {
                  final index = entry.key;
                  final coordinate = entry.value;
                  return Positioned(
                    left: coordinate['x'],
                    top: coordinate['y'],
                    child: GestureDetector(
                      // Se segurar em cima do botão, ele é apagado
                      onLongPress: () async {

                        // Aqui o diabo chorou
                        // Só da pra ver que apagou se abrir de novo, pelo menos no web, tem q consertar isso

                        var collection = FirebaseFirestore.instance.collection('coordinates2');
                        var querySnapshots = await collection.get();
                        var documentID = querySnapshots.docs.elementAt(index).id;
                        
                        await FirebaseFirestore.instance.collection('coordinates2').doc(documentID).delete();

                        //Até o momento nao serve pra nada, mas ideia era que recarregasse a página pra ver as mudanças
                        //Basicamente chamando a página de novo

                        ref.refresh(coordinatesProvider); // Atualiza a página    
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

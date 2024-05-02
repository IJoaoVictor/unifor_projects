// ignore_for_file: deprecated_member_use

import 'package:belmondoproject/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Fazer a mesma coisa do send_video pra cá

// ignore: must_be_immutable
class videoDetails extends StatefulWidget {

  var videoName;
  
  videoDetails({super.key, required this.videoName});

  @override
  State<videoDetails> createState() => _videoDetailsState();
}

class _videoDetailsState extends State<videoDetails> {

  late VideoPlayerController _videoPlayerController;

  bool videoExists = false;

  
  
  @override
  void initState(){
    super.initState();
    // Procura na coleção um vídeo que tenha o mesmo nome da foto

    _videoPlayerController = VideoPlayerController.network('');

    

    getVideoPorNome(widget.videoName).then((value) {
      
      if (value != null) {

        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text('Aguardando banco de dados...')));
    

        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Mídia carregada com sucesso!')));
        
      }
    },);

    getVideoPorNome(widget.videoName).then((value) {

      if (value == null) {

        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                            content: Text('Aguardando banco de dados...')));
    
        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Não há versão interativa desta obra')));
        
      }
    },);
    
    getVideoPorNome(widget.videoName).then((value) {
      
      _videoPlayerController = VideoPlayerController.network(value!)
    ..initialize().then((context) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
      setState(() {});
    }
    );  
    },); 

    
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }


  @override

  Widget build(BuildContext context) {


    CollectionReference _reference = FirebaseFirestore.instance.collection('videos');

    Reference storageReferance = FirebaseStorage.instance.ref();
    

    return Scaffold(

      appBar: AppBar(
          title: Text(widget.videoName),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          
          actions: [
            if (isUserAuthenticated())
            
            IconButton(onPressed: () async {
            //Delete the item

            await _reference.where('name', isEqualTo: widget.videoName).get().then((querySnapshot) {
              querySnapshot.docs.forEach((doc) async {
              final desertRef = storageReferance.child("videos/${widget.videoName}.mp4");
              await desertRef.delete();
              await doc.reference.delete();
              });
            });
            
            Navigator.pop(context);
          },
          
          icon: Icon(Icons.delete)),
          ],
        ),
        
      body: Stack(children: [

        Center(child: Text("Pode não haver versão interativa desta obra")),
      
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: _videoPlayerController?.value?.size?.height ?? 0,
              width: _videoPlayerController?.value?.size?.width ?? 0,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        )
      ],),
    );
  }



Future<String?> getVideoPorNome(String nome) async {
  CollectionReference _reference = FirebaseFirestore.instance.collection('videos');

  QuerySnapshot querySnapshot = await _reference.where('name', isEqualTo: nome).get();

  if (querySnapshot.docs.isNotEmpty) {
    // O item com o nome específico foi encontrado
    DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    // Retorna o valor do campo 'video' do documento encontrado
    return documentSnapshot['video'] as String?;
  } else {
    // Nenhum item encontrado com o nome especificado.
    return null;
  } 

 
}


}
// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class sendVideo extends StatefulWidget {
  
  var videoName;

  sendVideo({Key? key, required this.videoName}) : super(key: key);

  @override
  State<sendVideo> createState() => _sendVideoState();
}

class _sendVideoState extends State<sendVideo> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference = FirebaseFirestore.instance.collection('videos');

  String videoUrl = '';  

  bool videoSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vídeo de " + widget.videoName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Nome do vídeo '),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome para o vídeo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                decoration:
                    InputDecoration(hintText: 'Descrição do vídeo '),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira uma descrição para o vídeo';
                  }
                  return null;
                },
              ),
              Text(""),
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickVideo(source: ImageSource.gallery);
                  print('${file?.path}');

                  
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirVideos =
                      referenceRoot.child('videos');

                  Reference referenceVideoToUpload =
                      referenceDirVideos.child(widget.videoName+".mp4");

                  try {
                    await referenceVideoToUpload.putFile(File(file!.path));
                    videoUrl = await referenceVideoToUpload.getDownloadURL();

                    if (videoUrl.isNotEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Vídeo carregado com sucesso')));
                      setState(() {
                        videoSelected = true;
                      });
                    }
                  } catch (error) {
                    // Trate o erro adequadamente
                  }
                },
                child: Text("Adicionar arquivo"),
              ),
              
              Text(""),
              
              if (videoSelected)
                Text("Vídeo selecionado"),
              
              if (!videoSelected)
                Text("Aguarde até o vídeo ser carregado. Ele será exibido na tela logo após."),
              
              Text(""),
              
              if (videoSelected)
                ElevatedButton(
                  onPressed: () async {
                    if (videoUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Nenhum arquivo selecionado')));
                      return;
                    }

                    if (key.currentState!.validate()) {
                      String videoName = widget.videoName;
                      String videoDescription = _controllerDescription.text;

                      Map<String, String> dataToSend = {
                        'name': videoName,
                        'description': videoDescription,
                        'video': videoUrl,
                      };

                      _reference.add(dataToSend);
                    }
                    Navigator.pop(context);
                  },
                  
                  child: Text('Enviar'),                  
                ),
                
                
            ],
          ),
        ),
      ),
    );
  }
}

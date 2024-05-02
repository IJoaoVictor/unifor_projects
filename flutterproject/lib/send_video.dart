import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SendVideo extends StatefulWidget {
  final String videoName;

  const SendVideo({Key? key, required this.videoName}) : super(key: key);

  @override
  State<SendVideo> createState() => _SendVideoState();
}

class _SendVideoState extends State<SendVideo> {
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
        title: Text("Vídeo de ${widget.videoName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(
                  label: Text("Nome"),
                  hintText: 'Insira o nome do vídeo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                decoration: InputDecoration(
                  label: Text("Descrição"),
                  hintText: 'Insira a descrição do vídeo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição obrigatória';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file =
                      await imagePicker.pickVideo(source: ImageSource.gallery);
                  print('${file?.path}');

                  if (file != null) { // Verifica se um vídeo foi selecionado
                    try {
                      // String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceRoot =
                          FirebaseStorage.instance.ref();
                      Reference referenceDirVideos =
                          referenceRoot.child('videos');

                      Reference referenceVideoToUpload =
                          referenceDirVideos.child(widget.videoName + ".mp4");

                      await referenceVideoToUpload.putFile(File(file.path));
                      videoUrl =
                          await referenceVideoToUpload.getDownloadURL();

                      if (videoUrl.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Vídeo carregado com sucesso'),
                          ),
                        );
                        setState(() {
                          videoSelected = true;
                        });
                      }
                    } catch (error) {
                      // Trate o erro adequadamente
                      print(error);
                    }
                  } else {
                    // Exibir mensagem de erro aqui se necessário
                  }
                },
                child: Text("Adicionar arquivo"),
              ),
              SizedBox(height: 16),
              if (videoSelected)
                Text("Vídeo selecionado"),
              if (!videoSelected)
                Text("Aguarde até o vídeo ser carregado. Ele será exibido na tela logo após."),
              SizedBox(height: 16),
              if (videoSelected)
                ElevatedButton(
                  onPressed: () async {
                    if (videoUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Nenhum arquivo selecionado'),
                        ),
                      );
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

                      try {
                        await _reference.add(dataToSend);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Vídeo enviado com sucesso!'),
                          ),
                        );
                        // Limpa os campos após o envio bem-sucedido
                        _controllerName.clear();
                        _controllerDescription.clear();
                        setState(() {
                          videoSelected = false;
                        });
                      } catch (error) {
                        // Trate o erro adequadamente
                        print(error);
                      }
                      Navigator.pop(context);
                    }
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

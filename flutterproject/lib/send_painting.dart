import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class sendPainting extends StatefulWidget {
  const sendPainting({Key? key}) : super(key: key);

  @override
  State<sendPainting> createState() => _sendPaintingState();
}

class _sendPaintingState extends State<sendPainting> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('images');

  String imageUrl = '';

  bool ImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envio de Pinturas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  controller: _controllerName,
                  decoration: InputDecoration(labelText: 'Nome da obra '),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um nome para a obra';
                    }
        
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerDescription,
                  decoration: InputDecoration(labelText: 'Setor da Obra '),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um setor para a obra';
                    }
                    return null;
                  },
                ),
                Text(""),
                ElevatedButton(
                    onPressed: () async {
        
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file =
                          await imagePicker.pickImage(source: ImageSource.gallery);
                      print('${file?.path}');
        
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
        
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');
        
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName+".jpg");
        
                      try {
        
                        await referenceImageToUpload.putFile(File(file!.path));
                        imageUrl = await referenceImageToUpload.getDownloadURL();
        
                        // Tem que esperar um pouquinho pra imagem carregar
                        if (imageUrl.isEmpty == false) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Carregando arquivo, aguarde...')));
                        setState(() {
                        ImageSelected = true; 
                      });
        
        
                       }
                       
                      } catch (error) {
                        
                      }
                    },
                    child: Text("Adicionar arquivo")),
               
                
                Text(""),
                if (ImageSelected == true)  // Verifica se imageUrl não está vazia
                
                Column(
                  children: [
                    Text("Arquivo escolhido"),
                    Text(""),
                    SizedBox(
                      height: 400,
                      width: 400,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover, // Ajuste conforme necessário
                      
                        ),
                      ),
                    ),
                  ],
                ),
        
                if (ImageSelected == false)
                Text("Aguarde até o arquivo ser carregado. Ele será exibido na tela logo após."),
                
                if (ImageSelected == true)
                Text(""),
                
                if (ImageSelected == true)
                ElevatedButton(
                    onPressed: () async {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Nenhum arquivo selecionado')));
        
                        return;
                      }
        
                      if (key.currentState!.validate()) {
                        String itemName = _controllerName.text;
                        String itemDescription = _controllerDescription.text;
        
                        //Create a Map of data
                        Map<String, String> dataToSend = {
                          'name': itemName,
                          'description': itemDescription,
                          'image': imageUrl,
                        };
        
                        //Add a new item
                        _reference.add(dataToSend);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Enviar')),
              ],
            ),
          ),
        ),
      ),
    );
  }  
}

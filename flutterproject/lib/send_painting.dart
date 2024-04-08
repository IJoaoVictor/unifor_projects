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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Nome da Obra '),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome para a obra';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerDescription,
                decoration:
                    InputDecoration(hintText: 'Descrição da Obra '),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira uma descrição para a obra';
                  }

                  return null;
                },
              ),
              Text(""),
              ElevatedButton(
                  onPressed: () async {
                    /*
                * Step 1. Pick/Capture an image   (image_picker)
                * Step 2. Upload the image to Firebase storage
                * Step 3. Get the URL of the uploaded image
                * Step 4. Store the image URL inside the corresponding
                *         document of the database.
                * Step 5. Display the image on the list
                *
                * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.gallery);
                    print('${file?.path}');

                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName+".jpg");

                    //Handle errors/success
                    try {

                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();

                      
                      // Tem que esperar um pouquinho pra imagem carregar
                      if (imageUrl.isEmpty == false) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Carregando arquivo, aguarde...')));
                      setState(() {
                      ImageSelected = true; // Set variable back to false if image is selected
                    });


                     }
                     
                    } catch (error) {
                      //Some error occurred
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
    );
  }  
}


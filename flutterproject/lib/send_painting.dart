import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SendPainting extends StatefulWidget {
  const SendPainting({Key? key}) : super(key: key);

  @override
  State<SendPainting> createState() => _SendPaintingState();
}

class _SendPaintingState extends State<SendPainting> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('images');

  String imageUrl = '';

  bool imageSelected = false;

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
                  decoration: InputDecoration(
                    hintText: "Insira o nome da obra",
                    labelText: 'Nome'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerDescription,
                  decoration:
                      InputDecoration(
                        hintText: "Insira o setor da obra",
                        labelText: 'Setor'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Setor obrigatório';
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

                    if (file != null) {
                      try {
                        // String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        Reference referenceImageToUpload =
                            referenceDirImages.child(_controllerName.text + ".jpg");

                        await referenceImageToUpload.putFile(File(file.path));
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();

                        if (imageUrl.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Carregando arquivo, aguarde...')));
                          setState(() {
                            imageSelected = true;
                          });
                        }
                      } catch (error) {
                        print(error);
                      }
                    } else {
                      // Exibir mensagem de erro aqui se necessário
                    }
                  },
                  child: Text("Adicionar arquivo"),
                ),
                Text(""),
                if (imageSelected)
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (!imageSelected)
                  Text("Aguarde até o arquivo ser carregado. Ele será exibido na tela logo após."),
                if (imageSelected)
                  Text(""),
                if (imageSelected)
                  ElevatedButton(
                    onPressed: () async {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Nenhum arquivo selecionado')));

                        return;
                      }

                      if (key.currentState!.validate()) {
                        String itemName = _controllerName.text;
                        String itemSector = _controllerDescription.text;

                        Map<String, String> dataToSend = {
                          'name': itemName,
                          'sector': itemSector,
                          'image': imageUrl,
                        };

                        try {
                          await _reference.add(dataToSend);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Imagem enviada com sucesso!')));
                          // Limpa os campos após o envio bem-sucedido
                          _controllerName.clear();
                          _controllerDescription.clear();
                          setState(() {
                            imageSelected = false;
                          });
                        } catch (error) {
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaintingDetails extends StatelessWidget {
  const PaintingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("O Viajante"),
          centerTitle: true,
          leading: 
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back))
        ),

        body: Stack(
          children: [    
            Container(
              decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("lib/images/image1.jpg"),
              fit: BoxFit.cover)
            ),
          ),
          
          // Positioned serve pra colocar o botão num lugar específico

          // Cada positioned vai ser um botão em um lugar diferente
          Positioned(
            left: 160, 
            bottom: 350,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Acredita-se que este homem passou a vagar pelo mundo após não conseguir entender a Pipeline do Átila"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("1"),)),


            Positioned(
            left: 40,
            bottom: 450,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("O homem admira o horizonte de Itaitinga"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("2"),)),


            Positioned(
            left: 160,
            bottom: 100,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("As rochas simbolizam os obstáculos que o pai de familia precisa escalar para sobreviver com um salário mínimo que absurdo olha esse país está indo ladeira abaixo faça algo Lula"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("3"),)),

            Positioned(
            left: 300,
            bottom: 500,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("O céu azul como o mar (provavelmente foi pintado antes do aquecimento global tomar conta)"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("4"),)),

            Positioned(
            left: 0,
            bottom: 0,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("O céu azul como o mar (provavelmente foi pintado antes do aquecimento global tomar conta)"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("4"),)),
          ]

          

          
        )
        
        )
    );
  }
}
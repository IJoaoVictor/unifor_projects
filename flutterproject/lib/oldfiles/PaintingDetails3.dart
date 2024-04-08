import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaintingDetails3 extends StatelessWidget {
  const PaintingDetails3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Não sei quem é"),
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
              image: DecorationImage(image: AssetImage("lib/images/image3.jpg"),
              fit: BoxFit.cover)
            ),
          ),
          
          Positioned(
            left: 50,
            bottom: 200,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Lusimara (o nome dela) ((meio estranho)) quebrou a quarta parede ao olhar para a camera"),

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
                    content: Text("Não sei mais o que escrever"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("774"),)),


            Positioned(
            left: 160,
            bottom: 100,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("O maior medo dela era perder pai e mae"),

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
                    content: Text("Talvex ela tivexe vergonha de mosxtrar o cavelo (barbeira cortou demais)"),

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
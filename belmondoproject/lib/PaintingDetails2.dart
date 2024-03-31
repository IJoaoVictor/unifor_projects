import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaintingDetails2 extends StatelessWidget {
  const PaintingDetails2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Beethoven"),
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
              image: DecorationImage(image: AssetImage("lib/images/image2.jpg"),
              fit: BoxFit.cover)
            ),
          ),
          
          Positioned(
            left: 40,
            bottom: 200,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Anotano as proposisão logica..."),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("1"),)),


            Positioned(
            left: 100,
            bottom: 600,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Ele platinou seus cabelos para ficar mais gatinho (tendência forte em 1764)"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("2"),)),

            Positioned(
            left: 300,
            bottom: 500,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("ele era SURDO como q esse cara escrevia musica impossivel"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("3"),)),
          ]

          
        )
        
        )
    );
  }
}
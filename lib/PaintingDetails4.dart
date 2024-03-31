import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaintingDetails4 extends StatelessWidget {
  const PaintingDetails4({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("A Monalisa"),
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
              image: DecorationImage(image: AssetImage("lib/images/image4.jpg"),
              fit: BoxFit.cover)
            ),
          ),
          
          Positioned(
            left: 80,
            bottom: 350,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Ela não faz ideia do que é um computador"),

                    actions: [

                      ElevatedButton(
                        onPressed: () {
                        Navigator.pop(context);}, 
                        child: Text("OK"))
                    ],

                  ));
              }, child: Text("1"),)),


            Positioned(
            left: 160,
            bottom: 100,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text("Acredita-se que a Mona(lisa) cruzou as mãos por um motivo bastante peculiar: não faço ideia"),

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
                    content: Text("A obra foi pintada por Leonardo DiCaprio"),

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
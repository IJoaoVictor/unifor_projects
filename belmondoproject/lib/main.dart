import 'package:belmondoproject/PaintingDetails2.dart';
import 'package:belmondoproject/PaintingDetails3.dart';
import 'package:belmondoproject/PaintingDetails4.dart';
import 'package:belmondoproject/firebase_options.dart';
import 'package:belmondoproject/velho.dart';
import 'package:belmondoproject/gogh.dart';
import 'package:belmondoproject/viajante.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

// Na PaintingDetails tem o processo padrão onde os pontos são colocados manualmente
// Na Gogh (mesma coisa pro velho) tem usando banco de dados


void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: HomePage()));
  runApp(ProviderScope(child: HomePage())); // Bagulho necessário pra criar Pontos em qualquer lugar
}

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        appBar: AppBar(
          title: Text("Acervo da Unifor"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.purple),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage("lib/images/profile.jpeg"),
                      radius: 50,
                    ),
                    Text("Bill Gates"),
                  ],
                )),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.search),
              title: Text("Pesquisar"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.favorite),
              title: Text("Favoritos"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.logout),
              title: Text("Sair"),
            ),
          ]),
        ),
        // O Grid das imagens
        body: MasonryGridView.builder(itemCount:6, //Quantidade de pinturas mostradas no grid, talvez se a gente arrumar um modo de contar quantas fotos tem em cada pasta, dá pra fazer automático
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2 ), itemBuilder: (context, index) => 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: GestureDetector(
              onTap: () {
                
                // Cada foto possui um index, caso seja indice tal, vai pra página tal
                // Deve ter como melhorar isso com um for e uma lista contendo o nome de cada página
                // Até o momento, tem que ter uma página pra cada foto

                if (index == 0) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Traveller()));
              
                if (index == 1) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintingDetails2()));

                if (index == 2) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintingDetails3()));

                if (index == 3) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaintingDetails4()));

                if (index == 4) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const velho()));

                if (index == 5) 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Gogh()));

              
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Arredondando as bordas da foto
                child: Image.asset('lib/images/image${index + 1}.jpg')), // Se as fotos tiverem no padrao "image+numero", busca logo todas as fotos que tem na pasta
            ),
          ),
        ),)
          
      ),
    );
  }


}
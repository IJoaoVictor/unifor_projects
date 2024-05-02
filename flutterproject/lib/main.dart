import 'package:belmondoproject/auth/login.dart';
import 'package:belmondoproject/home_page.dart';
import 'package:flutter/material.dart';
import 'package:belmondoproject/firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: MyApp()));
  runApp(ProviderScope(child: MyApp())); // Bagulho necessário pra criar Pontos em qualquer lugar

}

class MyApp extends StatelessWidget  with WidgetsBindingObserver{
  
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
      useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,

        
      )),

      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
      }
    );
  }
}
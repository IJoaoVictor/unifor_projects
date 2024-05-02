import 'dart:developer';

import 'package:belmondoproject/auth/auth_service.dart';
import 'package:belmondoproject/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = AuthService(); //Instância dos serviços de autorização do firebase
  final _email = TextEditingController(); // Variáveis que vão armazenar o valor dos campos
  final _password = TextEditingController();


  // Chamada do método que vai destruir esses elementos pra liberar memória
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login | ExplorArt",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              
              const SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  hintText: "Digite o e-mail de acesso",
                  label: Text("E-mail"),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person)
                ),
                controller: _email,
              ),
              
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Digite a senha",
                  label: Text("Senha"),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.password)
                ),
                controller: _password,
              ),
              
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  fixedSize: const Size(double.maxFinite, 60),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.blue),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                child: Text("L O G I N"),
                onPressed: _login,
              ),
              
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(double.maxFinite, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                child: Text("V I S I T A N T E"),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/home'); //Tem que usar popPushNamed
                },
              ),
             
              const SizedBox(height: 5),

            ],
          ),
        ),
      ),
    
    );
    
  }



  _login() async {

    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text); // Chama a função em auth_service.dart

    // Se o usuário não estiver vazio, passa pra próxima tela
    if (user != null) {
      log("Usuário entrou");
      Navigator.popAndPushNamed(context, '/home');

    // Caso não
    } else {

      showDialog(
        
        context: context,
        builder: (context) => AlertDialog(
                                
        content: Text("E-mail ou senha incorretos"),
                                
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Continuar"),
            ),
          ],
       ),
      );
    }
  }
}
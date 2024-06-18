import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'user_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores de texto para os campos de email e senha
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  void _login() async {
    try {
      // Tentativa de login com email e senha
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Referência ao nó do usuário no Realtime Database
      DatabaseReference userRef =
      _database.ref().child('users/${userCredential.user!.uid}');
      // Verifica se o usuário já existe no Realtime Database
      userRef.once().then((DatabaseEvent event) {
        if (event.snapshot.value == null) {
          // Se não existir, cria o usuário no Realtime Database
          userRef.set({
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
          });
        }
      });

      final db = FirebaseFirestore.instance; // Instância do Firestore
      List<Map<String, dynamic>> userHashes = []; // Lista para armazenar hashes dos usuários

      // Obtém os dados dos usuários do Firestore
      db.collection("users").get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            userHashes.add({
              'id': docSnapshot.id,
              'data': docSnapshot.data(),
            });
            print(docSnapshot.id);
          }

          // Navega para a tela UserListScreen, passando os hashes dos usuários
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserListScreen(userHashes: userHashes),
            ),
          );
        },
        onError: (e) => print("Error completing: $e"),
      );
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset('imagens/puctime.png'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

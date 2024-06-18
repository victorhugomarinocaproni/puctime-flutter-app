import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'discipline_screen.dart';
import 'login_screen.dart';

class UserListScreen extends StatelessWidget {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Map<String, dynamic>> userHashes;

  UserListScreen({required this.userHashes});

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userHashes.length,
        itemBuilder: (context, index) {
          var user = userHashes[index];
          return ListTile(
            title: Text(user['data']['email'] ?? 'No Email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisciplineScreen(userId: user['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

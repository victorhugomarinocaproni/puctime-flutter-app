import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'new_apontamento_screen.dart';
import 'package:intl/intl.dart';

class DisciplineScreen extends StatelessWidget {
  final String userId;

  DisciplineScreen({required this.userId});

  // Função para criar um novo apontamento
  void _createNewApontamento(BuildContext context) async {
    // Referência ao local onde os logs são armazenados
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$userId');

    // Dados do novo apontamento
    Map<String, dynamic> newApontamento = {
      'dataCriacaoAponamento': DateFormat('EEE MMM dd HH:mm:ss z yyyy').format(DateTime.now()), // Data atual formatada
      'diaDaSemana': DateFormat('EEEE').format(DateTime.now()), // Dia da semana atual
      'horarioInicio': DateFormat('HH:mm').format(DateTime.now()), // Hora atual
      'horarioTermino': DateFormat('HH:mm').format(DateTime.now()), // Hora atual
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // ID único baseado no timestamp atual
      'nome': 'novoApontamento',
      'status': 'aberto',
    };

    // Adiciona o novo apontamento ao Realtime Database
    DatabaseReference newuserRef = userRef.push();
    await newuserRef.set(newApontamento);

    // Navega para a tela de edição do novo apontamento
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(
          userId: userId,
          apontamentoId: newuserRef.key!,
          userData: newApontamento,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Referência aos Apontamentos de usuário no Realtime Database
    final DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$userId');

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DatabaseEvent>(
          stream: userRef.onValue, // Escuta as mudanças nos Apontamentos do usuário
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Text('Apontamentos'); // Texto padrão se não há dados
            }

            List<dynamic> apontamentos = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>).values.toList();

            int total = apontamentos.length;
            int abertos = apontamentos.where((a) => a['status'] == 'aberto').length;
            int fechados = apontamentos.where((a) => a['status'] == 'fechado').length;

            double percentualAbertos = (total > 0) ? (abertos / total) * 100 : 0;
            double percentualFechados = (total > 0) ? (fechados / total) * 100 : 0;

            return Text('Apontamentos Abertos: ${percentualAbertos.toStringAsFixed(1)}%, Fechados: ${percentualFechados.toStringAsFixed(1)}%');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _createNewApontamento(context), // Aqui passamos o context
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.onValue, // Escuta as mudanças nos Apontamentos do usuário
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator()); // Mostra indicador de progresso se não há dados
          }

          List<dynamic> apontamentos = [];
          if (snapshot.data!.snapshot.value != null) {
            // Converte os dados em uma lista
            apontamentos = (snapshot.data!.snapshot.value as Map<dynamic, dynamic>).entries.toList();
          }

          return ListView.builder(
            itemCount: apontamentos.length, // Número de Apontamentos
            itemBuilder: (context, index) {
              var userEntry = apontamentos[index];
              var userId = userEntry.key; // ID do log
              var userData = userEntry.value; // Dados do Apontamentos

              return ListTile(
                title: Text('Apontamento ${index + 1}'), // Exibe o número do Apontamentos
                subtitle: Text(
                  'Início: ${userData['horarioInicio']}, '
                      'Término: ${userData['horarioTermino']}, '
                      'Dia da Semana: ${userData['diaDaSemana']},'
                      'Data: ${userData['dataCriacaoAponamento']} ',
                ), // Exibe o horário de início e término
              );
            },
          );
        },
      ),
    );
  }
}

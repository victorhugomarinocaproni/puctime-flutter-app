import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditScreen extends StatefulWidget {
  final String userId; // ID do usuário
  final String apontamentoId; // ID do apontamento
  final Map<dynamic, dynamic> userData; // Dados do apontamento

  EditScreen(
      {required this.userId,
      required this.apontamentoId,
      required this.userData});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário
  late TextEditingController _dataCriacaoAponamentoController;
  late TextEditingController _diaDaSemanaController;
  late TextEditingController _horarioInicioController;
  late TextEditingController _horarioTerminoController;
  late TextEditingController _idController;
  late TextEditingController _nomeController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores com os dados atuais do apontamento
    _dataCriacaoAponamentoController = TextEditingController(
        text: widget.userData['dataCriacaoAponamento'] ?? '');
    _diaDaSemanaController =
        TextEditingController(text: widget.userData['diaDaSemana'] ?? '');
    _horarioInicioController =
        TextEditingController(text: widget.userData['horarioInicio'] ?? '');
    _horarioTerminoController =
        TextEditingController(text: widget.userData['horarioTermino'] ?? '');
    _idController = TextEditingController(text: widget.userData['id'] ?? '');
    _nomeController = TextEditingController(text: widget.userData['nome'] ?? '');
    _statusController =
        TextEditingController(text: widget.userData['status'] ?? '');
  }

  // Função para salvar os dados editados
  void _saveLog() async {
    if (_formKey.currentState!.validate()) {
      // Referência ao apontamento específico no Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users/${widget.userId}/${widget.apontamentoId}');

      // Atualiza o Apontamento com os novos dados
      await userRef.update({
        'dataCriacaoAponamento': _dataCriacaoAponamentoController.text,
        'diaDaSemana': _diaDaSemanaController.text,
        'horarioInicio': _horarioInicioController.text,
        'horarioTermino': _horarioTerminoController.text,
        'id': _idController.text,
        'nome': _nomeController.text,
        'status': _statusController.text,
      });
      print("atualizou");

      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados Apontamento'), // Título da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
              children: [
                // Campo de texto para editar a data de criação do apontamento
                TextFormField(
                  controller: _dataCriacaoAponamentoController,
                  decoration:
                      InputDecoration(labelText: 'Data Criação Apontamento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data de criação';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o dia da semana
                TextFormField(
                  controller: _diaDaSemanaController,
                  decoration: InputDecoration(labelText: 'Dia da Semana'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o dia da semana';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o horário de início
                TextFormField(
                  controller: _horarioInicioController,
                  decoration: InputDecoration(labelText: 'Horário Início'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o horário de início';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o horário de término
                TextFormField(
                  controller: _horarioTerminoController,
                  decoration: InputDecoration(labelText: 'Horário Término'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o horário de término';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o ID
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ID';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Campo de texto para editar o status
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: 'Status'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o status';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Botão para salvar as alterações
                ElevatedButton(
                  onPressed: _saveLog,
                  child: Text('Salvar'),
                ),
              ],
          ),
        ),
      ),
    );
  }
}

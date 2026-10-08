import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TesteApi extends StatefulWidget {
  const TesteApi({super.key});

  @override
  State<TesteApi> createState() => _TesteApiState();
}

class _TesteApiState extends State<TesteApi> {
  String mensagem = 'Toque no botão para testar';

  Future<void> testar() async {
    try {
      final resposta = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/noticias'),
      );

      if (resposta.statusCode == 200) {
        mensagem = 'Conectou Com Sucesso';
      } else {
        mensagem = 'Api respondeu com erro ${resposta.statusCode}';
      }
    } catch (erro) {
      mensagem = 'Não Conectou erro: $erro';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: testar, child: const Text('Testar API')),
            const SizedBox(height: 16),
            Text(mensagem),
          ],
        ),
      ),
    );
  }
}

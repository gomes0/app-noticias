import 'package:app_noticias_tii/models/noticia.dart';
import 'package:app_noticias_tii/services/noticias_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/noticia.dart';

class TesteApi extends StatefulWidget {
  const TesteApi({super.key});

  @override
  State<TesteApi> createState() => _TesteApiState();
}

class _TesteApiState extends State<TesteApi> {
  String mensagem = 'Toque no botão para testar';

  final NoticiasService _noticiasService = NoticiasService();

  late Future<List<Noticia>> _listaNoticias;

  Future<void> carregarNoticias() async {
    _listaNoticias = _noticiasService.getNoticias();

    List<Noticia> noticias = await _listaNoticias;

    print("--- Teste No Console ---");
    print('Quantidade de notícias: ${noticias.length}');
  }

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
            ElevatedButton(
              onPressed: carregarNoticias,
              child: const Text('Carregar Notícias'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/categoria.dart';

class CategoriasService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Categoria>> getCategorias() async {
    try {
      final resposta = await http.get(Uri.parse('$baseUrl/categorias'));
      if (resposta.statusCode == 200) {
        final List dados = jsonDecode(resposta.body);
        return dados.map((item) => Categoria.fromJson(item)).toList();
      } else {
        throw Exception('Não foi possivel carregar as categorias');
      }
    } catch (e) {
      throw Exception('Não conectou erro: $e');
    }
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<String> login(String email, String senha) async {
    try {
      final resposta = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': senha},
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        final String token = dados['token'];
        final String nome = dados['usuario']['nome'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('nome', nome);
        return nome;
      }

      if (resposta.statusCode == 401 || resposta.statusCode == 422) {
        throw Exception('E-mail ou Senha inválidos');
      }

      throw Exception('Erro ao realizar login');
    } on http.ClientException {
      throw Exception('Não foi possível conectar ao Servidor');
    } on FormatException {
      throw Exception('Resposta inválida do servidor');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('nome');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }
}

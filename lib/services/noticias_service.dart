import 'dart:convert';
import 'dart:io';
import '../models/noticia.dart';
import '../services/login_service.dart';
import 'package:http/http.dart' as http;

class NoticiasService {
  final LoginService _loginService = LoginService();

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Noticia>> getNoticia() async {
    try {
      final resposta = await http.get(Uri.parse('$baseUrl/noticias'));

      if (resposta.statusCode == 200) {
        final List dados = jsonDecode(resposta.body);
        return dados.map((item) => Noticia.fromJson(item)).toList();
      } else {
        throw Exception('Não foi possível carregar as notícias.');
      }
    } catch (e) {
      throw Exception(_limparErro(e));
    }
  }

  Future<void> criarNoticia({
    required String titulo,
    required String resumo,
    required String conteudo,
    required int categoriaId,
    File? imagemArquivo,
  }) async {
    try {
      if (imagemArquivo == null) {
        throw Exception(
          'Não foi possível cadastrar a notícia. Todos os campos são obrigatórios.',
        );
      }

      final token = await _loginService.getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/noticias'),
      );
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['titulo'] = titulo;
      request.fields['resumo'] = resumo;
      request.fields['conteudo'] = conteudo;
      request.fields['categoria_id'] = categoriaId.toString();
      request.files.add(
        await http.MultipartFile.fromPath('imagem', imagemArquivo.path),
      );

      final resposta = await request.send();

      if (resposta.statusCode != 200 && resposta.statusCode != 201) {
        throw Exception('Não foi possível cadastrar a notícia.');
      }
    } catch (e) {
      throw Exception(_limparErro(e));
    }
  }

  Future<void> editarNoticia({
    required int id,
    required String titulo,
    required String resumo,
    required String conteudo,
    required int categoriaId,
    File? imagemArquivo,
  }) async {
    try {
      final token = await _loginService.getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/noticias/$id'),
      );
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['_method'] = 'PUT';
      request.fields['titulo'] = titulo;
      request.fields['resumo'] = resumo;
      request.fields['conteudo'] = conteudo;
      request.fields['categoria_id'] = categoriaId.toString();

      if (imagemArquivo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('imagem', imagemArquivo.path),
        );
      }

      final resposta = await request.send();

      if (resposta.statusCode != 200) {
        throw Exception('Não foi possível editar a notícia.');
      }
    } catch (e) {
      throw Exception(_limparErro(e));
    }
  }

  String _limparErro(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}

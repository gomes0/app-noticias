import 'package:app_noticias_tii/models/categoria.dart';
import 'package:app_noticias_tii/services/categorias_services.dart';
import 'package:app_noticias_tii/services/noticias_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CadastrarNoticiaPage extends StatefulWidget {
  const CadastrarNoticiaPage({super.key});

  @override
  State<CadastrarNoticiaPage> createState() => _CadastrarNoticiaPageState();
}

class _CadastrarNoticiaPageState extends State<CadastrarNoticiaPage> {
  final NoticiasService _noticiaService = NoticiasService();
  final CategoriasService _categoriasService = CategoriasService();

  final _tituloController = TextEditingController();
  final _resumoController = TextEditingController();
  final _conteudoController = TextEditingController();

  File? _imagemSelecionada;
  List<Categoria> _categorias = [];
  int? _categoriaSelecionadaId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasService.getCategorias();

      if (!mounted) return;

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Notícia'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: InputDecoration(
              labelText: 'Título',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _tituloController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Resumo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _tituloController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Conteúdo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Imagem de Capa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                  label: const Text('Câmera'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.photo_library,
                  ),
                  label: const Text('Galeria'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Categorias',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            initialValue: _categoriaSelecionadaId,
            items: _categorias.map((categoria) {
              return DropdownMenuItem(
                child: Text(categoria.nome),
                value: categoria.id,
              );
            }).toList(),
            onChanged: (valor) {
              _categoriaSelecionadaId = valor;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Publicar Notícia'),
          ),
        ],
      ),
    );
  }
}

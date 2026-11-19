import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/categoria.dart';
import '../models/noticia.dart';
import '../services/categorias_services.dart';
import '../services/noticias_service.dart';

class CadastrarNoticiaPage extends StatefulWidget {
  final Noticia? noticia;
  const CadastrarNoticiaPage({super.key, this.noticia});

  @override
  State<CadastrarNoticiaPage> createState() => _CadastrarNoticiaPageState();
}

class _CadastrarNoticiaPageState extends State<CadastrarNoticiaPage> {
  final NoticiasService _noticiasService = NoticiasService();
  final CategoriasService _categoriasServices = CategoriasService();
  final ImagePicker _picker = ImagePicker();

  final _tituloController = TextEditingController();
  final _resumoController = TextEditingController();
  final _conteudoController = TextEditingController();

  File? _imagemSelecionada;
  List<Categoria> _categorias = [];
  int? _categoriaSelecionadaId;
  bool _status = true;
  bool _salvando = false;

  bool get _editando => widget.noticia != null;

  @override
  void initState() {
    super.initState();
    carregarCategorias();

    final noticia = widget.noticia;
    if (noticia != null) {
      _tituloController.text = noticia.titulo;
      _resumoController.text = noticia.resumo;
      _conteudoController.text = noticia.conteudo;
      _categoriaSelecionadaId = noticia.categoriaId;
      // Se status na classe Noticia for só bool: _status = noticia.status;
      // Se for int: _status = noticia.status == 1;
      _status = noticia.status == true || noticia.status == 1;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _resumoController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasServices.getCategorias();

      if (!mounted) return;

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _selecionarImagem(ImageSource origem) async {
    final arquivo = await _picker.pickImage(source: origem);
    if (arquivo != null) {
      setState(() {
        _imagemSelecionada = File(arquivo.path);
      });
    }
  }

  Future<void> _salvarNoticia() async {
    if (_salvando) return;

    if (_tituloController.text.trim().isEmpty ||
        _resumoController.text.trim().isEmpty ||
        _conteudoController.text.trim().isEmpty ||
        _categoriaSelecionadaId == null ||
        (!_editando && _imagemSelecionada == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    setState(() => _salvando = true);

    try {
      if (_editando) {
        await _noticiasService.editarNoticia(
          id: widget.noticia!.id,
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      } else {
        await _noticiasService.criarNoticia(
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _editando
                ? 'Notícia atualizada com sucesso'
                : 'Notícia cadastrada com sucesso',
          ),
        ),
      );
      // true avisa a tela anterior para recarregar a lista
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Erro ao salvar notícia: $e');
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar notícia: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Evita erro do Dropdown caso a categoria ainda não tenha carregado
    // ou não exista na lista.
    final categoriaValida =
        _categorias.any((c) => c.id == _categoriaSelecionadaId)
        ? _categoriaSelecionadaId
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Notícia' : 'Cadastrar Notícia'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          TextFormField(
            controller: _resumoController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Resumo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          TextFormField(
            controller: _conteudoController,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Conteúdo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          const Text(
            'Imagem de Capa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            height: 160,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFD7D7D7),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(3),
            ),
            child: _imagemSelecionada == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )
                : Image.file(
                    _imagemSelecionada!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, erro, stack) => const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selecionarImagem(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _selecionarImagem(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          DropdownButtonFormField<int>(
            // A key recria o campo quando as categorias terminam de carregar,
            // já que initialValue só é lido na criação do campo.
            key: ValueKey('categoria_${_categorias.length}'),
            decoration: const InputDecoration(
              labelText: 'Categorias',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            initialValue: categoriaValida,
            items: _categorias.map((categoria) {
              return DropdownMenuItem<int>(
                value: categoria.id,
                child: Text(categoria.nome),
              );
            }).toList(),
            onChanged: (valor) {
              setState(() {
                _categoriaSelecionadaId = valor;
              });
            },
          ),
          const SizedBox(height: 25),

          SwitchListTile(
            value: _status,
            contentPadding: EdgeInsets.zero,
            title: const Text('Publicação ativa'),
            onChanged: (valor) {
              setState(() {
                _status = valor;
              });
            },
          ),
          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: _salvando ? null : _salvarNoticia,
            child: _salvando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _editando ? 'Salvar alterações' : 'Publicar notícia',
                  ),
          ),
        ],
      ),
    );
  }
}

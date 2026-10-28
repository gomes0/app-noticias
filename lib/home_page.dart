import 'package:app_noticias_tii/login_page.dart';
import 'package:flutter/material.dart';
import 'package:app_noticias_tii/models/categoria.dart';
import 'package:app_noticias_tii/services/categorias_service.dart';
import '../detalhe_noticia_page.dart';
import '../models/noticia.dart';
import '../services/noticias_service.dart';
import '../sobre_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticiasService _noticiasService = NoticiasService();
  late Future<List<Noticia>> _listaNoticia;
  final CategoriasService _categoriaService = CategoriasService();

  List<Categoria> _listaCategoria = [];

  // Variável que estava em falta para controlar a categoria selecionada
  String _categoriaSelecionada = "Todas";

  bool _buscando = false;
  String _textoPesquisa = '';

  void carregarDados() {
    _listaNoticia = _noticiasService.getNoticias();
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriaService.getCategorias();

      if (!mounted) return;

      setState(() {
        _listaCategoria = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  List<Noticia> aplicarFiltro(List<Noticia> noticias) {
    // Filtrar por categoria selecionada (se for diferente de "Todas")
    var noticiasFiltradas = noticias;
    if (_categoriaSelecionada != "Todas") {
      noticiasFiltradas = noticiasFiltradas.where((noticia) {
        return noticia.categoriaNome.toLowerCase() ==
            _categoriaSelecionada.toLowerCase();
      }).toList();
    }

    // Filtrar por texto de pesquisa
    if (_textoPesquisa.isNotEmpty) {
      return noticiasFiltradas.where((noticia) {
        return noticia.titulo.toLowerCase().contains(
              _textoPesquisa.toLowerCase(),
            ) ||
            noticia.resumo.toLowerCase().contains(_textoPesquisa.toLowerCase());
      }).toList();
    }

    return noticiasFiltradas;
  }

  @override
  void initState() {
    super.initState();
    _listaNoticia = _noticiasService.getNoticias();
    carregarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                autofocus: true,
                cursorColor: Colors.black,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: (valor) {
                  setState(() {
                    _textoPesquisa = valor;
                  });
                },
              )
            : Image.asset(
                'assets/img/logotipo.png',
                height: 20,
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _buscando = !_buscando;
                  if (!_buscando) {
                    _textoPesquisa = '';
                  }
                });
              },
              icon: Icon(_buscando ? Icons.close : Icons.search),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Image.asset(
                'assets/img/logotipo.png',
                height: 24,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Lista de Notícias'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SobrePage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Entrar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              itemCount: _listaCategoria.length + 1,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final categoria = index == 0
                    ? 'Todas'
                    : _listaCategoria[index - 1].nome;
                final selecionada = _categoriaSelecionada == categoria;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _categoriaSelecionada = categoria;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: selecionada
                              ? Colors.black
                              : const Color(0xFFEDEDED),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        categoria,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: selecionada
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Noticia>>(
              future: _listaNoticia,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          asyncSnapshot.error.toString().replaceFirst(
                            'Exception',
                            '',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              carregarDados();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final todasNoticias = asyncSnapshot.data ?? [];
                final noticias = aplicarFiltro(todasNoticias);

                if (noticias.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma notícia encontrada.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: noticias.length,
                  itemBuilder: (context, index) {
                    final noticia = noticias[index];

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalheNoticiaPage(noticia: noticia),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFFCBD2D9)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120,
                              color: const Color(0xFFE4E9EF),
                              child:
                                  noticia.imagem == null ||
                                      noticia.imagem!.isEmpty
                                  ? const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 35,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : Image.network(
                                      noticia.imagem!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stack) {
                                        return const Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            size: 35,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF4F8),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        child: Text(
                                          noticia.categoriaNome,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        noticia.dataFormatada,
                                        style: const TextStyle(
                                          color: Color(0xFF858D96),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    noticia.titulo,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    noticia.resumo,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF586879),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

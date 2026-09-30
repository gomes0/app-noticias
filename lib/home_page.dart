import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Map<String, dynamic>> noticias = [
    {
      'titulo': 'Nova tecnologia promete revolucionar os celulares',
      'resumo':
          'Uma nova tecnologia foi apresentada e promete melhorar o desempenho e a bateria dos smartphones.',
      'categoria': 'Tecnologia',
      'data': '23/09/2026',
    },
    {
      'titulo': 'Brasil ganha destaque no cenário internacional',
      'resumo':
          'O país recebeu destaque após novos avanços em tecnologia e inovação.',
      'categoria': 'Brasil',
      'data': '22/09/2026',
    },
    {
      'titulo': 'Novo jogo é lançado para consoles e PC',
      'resumo':
          'O aguardado jogo chegou ao mercado com gráficos aprimorados e novas funcionalidades.',
      'categoria': 'Games',
      'data': '21/09/2026',
    },
    {
      'titulo': 'Mercado de tecnologia apresenta crescimento',
      'resumo':
          'Empresas do setor registraram crescimento nas vendas durante o último trimestre.',
      'categoria': 'Economia',
      'data': '20/09/2026',
    },
    {
      'titulo': 'Aplicativo facilita o acesso às notícias',
      'resumo':
          'Uma nova plataforma foi criada para reunir notícias de diferentes categorias em um único lugar.',
      'categoria': 'Tecnologia',
      'data': '19/09/2026',
    },
  ];

  static final List<String> categorias = [
    "Todas",
    "Tecnologia",
    "Economia",
    "Games",
    "Brasil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logotipo.png',
          height: 22,
        ),
        centerTitle: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: categorias.map((categoria) {
                final selecionada = categoria == "Todas";

                return Container(
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
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFCBD2D9)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120,
                        color: const Color(0xFFE4E9Ef),
                        child: const Icon(Icons.image_outlined),
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
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF4F8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Text(noticia['categoria']),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  noticia['data'],
                                  style: const TextStyle(
                                    color: Color(0xFF858D96),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia['titulo'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1b2A4A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia['resumo'],
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

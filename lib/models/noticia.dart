class Noticia {
  final int id;
  final String titulo;
  final String conteudo;
  final String resumo;
  final int categoriaId;
  final String categoriaNome;
  final String? imagem;
  final DateTime createdAt;

  Noticia({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.resumo,
    required this.categoriaId,
    required this.categoriaNome,
    this.imagem,
    required this.createdAt,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      conteudo: json['conteudo'],
      resumo: json['resumo'],
      categoriaId: json['categoria_id'],
      categoriaNome: json['categoria_nome'],
      imagem: json['imagem'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get dataFormatada {
    final dia = createdAt.day.toString().padLeft(2, '0');
    final mes = createdAt.month.toString().padLeft(2, '0');
    final ano = createdAt.year.toString();
    return '$dia/$mes/$ano';
  }
}

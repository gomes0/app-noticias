class Noticia {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudo;
  final int categoriaId;
  final String categoriaNome;
  final String? imagem;
  final DateTime createdAt;
  final bool status;

  Noticia({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudo,
    required this.categoriaId,
    required this.categoriaNome,
    required this.imagem,
    required this.createdAt,
    this.status = true,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'],
      titulo: json['titulo'],
      resumo: json['resumo'],
      conteudo: json['conteudo'],
      categoriaId: json['categoria_id'],
      categoriaNome: json['categoria_nome'],
      imagem: json['imagem'],
      createdAt: DateTime.parse(json['created_at']),
      status: _converterStatus(json['status']),
    );
  }

  // Aceita true/false, 1/0 ou "1"/"0" vindos da API.
  // Se a API não enviar o campo, considera ativa.
  static bool _converterStatus(dynamic valor) {
    if (valor == null) return true;
    if (valor is bool) return valor;
    if (valor is num) return valor == 1;
    if (valor is String) return valor == '1' || valor.toLowerCase() == 'true';
    return true;
  }

  //07/05/2026
  String get dataFormatada {
    final dia = createdAt.day.toString().padLeft(2, '0');
    final mes = createdAt.month.toString().padLeft(2, '0');
    final ano = createdAt.year.toString();
    return '$dia/$mes/$ano';
  }
}
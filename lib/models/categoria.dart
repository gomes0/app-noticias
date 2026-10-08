class Categoria {
  final String id;
  final String nome;
  final String cor;

  Categoria({
    required this.id,
    required this.nome,
    required this.cor,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
      cor: json['cor'],
    );
  }
}

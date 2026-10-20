import 'package:flutter/material.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Portal de Notícias é um aplicativo desenvolvido, que vai consumir uma API própria desenvolvida em laravel',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF5B6B79),
          ),
        ),
      ),
    );
  }
}

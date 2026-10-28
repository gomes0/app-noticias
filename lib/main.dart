import 'package:app_noticias/home_page.dart';
import 'package:app_noticias/teste_api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Portal de Notícias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), //#F8FAFC
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 4.0,
        ),
      ),
      home: const HomePage(),
    ),
  );
}

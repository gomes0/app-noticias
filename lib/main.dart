import 'package:app_noticias_tii/home_page.dart';
import 'package:app_noticias_tii/teste_api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Portal de Noticias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
        ),
      ),
      //home: const HomePage(),
      home: const TesteApi(),
    ),
  );
}

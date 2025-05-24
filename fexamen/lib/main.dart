import 'package:fexamen/widget/inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Inicio(
        cor: '',
        pa: '',
      ),
    );
  }
}

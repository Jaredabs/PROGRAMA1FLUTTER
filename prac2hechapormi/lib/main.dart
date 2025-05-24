import 'package:flutter/material.dart';
import 'package:prac2hechapormi/widget/productos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*
hacer un programa que guarde en una base de datos una lista de compras, de n cantidad de productos, además se podrá modificar o eliminar uno de lista de los productos y un botón que me indique los productos comprados el iva y el total a pagar, la cual la mostrara como una alerta
  */
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Productos(),
    );
  }
}

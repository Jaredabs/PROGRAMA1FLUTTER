import 'package:flutter/material.dart';

class Pagina extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Pagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hola mundo'),
    );
  }
}

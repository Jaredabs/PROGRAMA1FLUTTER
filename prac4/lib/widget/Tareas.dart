import 'package:flutter/material.dart';
import 'package:prac4/widget/Agregar.dart';
import 'package:prac4/widget/Mostrar.dart';

class Tareas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Tareas> {
  int seleccionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'tareas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: seleccionIndex == 0 ? Agregar() : Mostrar(),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Agregar Tarea',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_outlined),
              label: 'Mostrar Tarea',
            ),
          ],
          currentIndex: seleccionIndex,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() {
              seleccionIndex = index;
            });
          }),
    );
  }
}

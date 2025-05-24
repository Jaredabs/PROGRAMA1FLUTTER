import 'package:fexamen/widget/Pagina2.dart';
import 'package:fexamen/widget/Pagina3.dart';
import 'package:fexamen/widget/inicio.dart';
import 'package:fexamen/widget/mostrar.dart';
import 'package:flutter/material.dart';

class Ultimo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return clase();
  }
}

class clase extends State<Ultimo> {
  int seleccionIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CRUD',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final route = MaterialPageRoute(
                builder: (_) => Inicio(cor: '', pa: ''),
              );
              Navigator.push(context, route);
            },
            child: Text('Regresar'),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 171, 50, 6),
      ),
      body: seleccionIndex == 0
          ? Mostrar()
          : (seleccionIndex == 1 ? Pagina2() : Pagina3()),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(100, 100, 100, 100),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
            ),
            label: 'Opcion 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessible,
            ),
            label: 'Opcion 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.accessible,
            ),
            label: 'Opcion 3',
          ),
        ],
        currentIndex: seleccionIndex,
        selectedItemColor: const Color.fromARGB(255, 241, 7, 7),
        onTap: (i) {
          setState(() {
            seleccionIndex = i;
          });
        },
      ),
    );
  }
}

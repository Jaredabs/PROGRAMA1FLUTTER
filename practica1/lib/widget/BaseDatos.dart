import 'package:flutter/material.dart';
import 'package:practica1/basedatos/BD.dart';
import 'package:practica1/widget/MostrarDatos.dart';

class Basedatos extends StatefulWidget {
  const Basedatos({super.key});

  @override
  State<StatefulWidget> createState() {
    return Ventana();
  }
}

class Ventana extends State<Basedatos> {
  final TextEditingController usuario = TextEditingController();
  final TextEditingController password = TextEditingController();

  void Agregar() async {
    String u = usuario.text;
    String p = password.text;

    if (u.isNotEmpty && p.isNotEmpty) {
      await BD().insertarUsuario(u, p);
      usuario.clear();
      password.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Datos'),
              content: Text('Guardados correctamente'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          });
    } else {
      //ALERTAS
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('ERROR'),
              content: Text('Cajas vacias'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          });

      //FIN
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practica con Base de datos'),
        backgroundColor: const Color.fromARGB(255, 255, 86, 53),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 400,
            color: const Color.fromARGB(255, 112, 167, 151),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: usuario,
                    decoration: InputDecoration(
                      hintText: 'Usuario:',
                    ),
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: 'Contraseña:',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text('Aceptar'),
                        onPressed: () {
                          Agregar();
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text('Mostrar Datos'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mostrardatos(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

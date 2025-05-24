import 'package:flutter/material.dart';
import 'package:practica1/basedatos/BD.dart';
import 'package:practica1/widget/BaseDatos.dart';
import 'package:practica1/widget/MostrarDatos.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Ventana();
  }
}

class Ventana extends State<Login> {
  final TextEditingController usuario = TextEditingController();
  final TextEditingController password = TextEditingController();

  void Agregar() async {
    String u = usuario.text;
    String p = password.text;

    if (u.isNotEmpty && p.isNotEmpty) {
      bool respuesta = await BD().ValidarUsuario(u, p);

      if (respuesta) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Basedatos()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Alerta'),
              content: Text('Usuario no encontrado'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
        usuario.clear();
        password.clear();
      }
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
        backgroundColor: const Color.fromARGB(255, 138, 122, 38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 400,
            color: const Color.fromARGB(255, 184, 194, 120),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: usuario,
                    decoration: InputDecoration(
                      labelText: 'Usuario:',
                    ),
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Contraseña:',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text('Validar'),
                        onPressed: () {
                          Agregar();
                        }),
                  ),
                  SizedBox(
                    height: 10,
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

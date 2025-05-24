import 'package:flutter/material.dart';
import 'package:practica1/basedatos/BD.dart';

class Mostrardatos extends StatefulWidget {
  const Mostrardatos({super.key});

  @override
  Lista createState() => Lista();
}

class Lista extends State<Mostrardatos> {
  List<Map<String, dynamic>> usuarios = [];
  @override
  void initState() {
    super.initState();
    obtenerUsuario();
  }

  void obtenerUsuario() async {
    List<Map<String, dynamic>> datos = await BD().obtenerUsuarios();
    setState(() {
      usuarios = datos;
    });
  }

  void EliminarUsuario(int id, String usu) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text('Estas Seguro de\n Eliminar a: $usu'),
            actions: [
              TextButton(
                onPressed: () {
                  Eliminar(id);
                  Navigator.pop(context);
                },
                child: Text('Si'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
            ],
          );
        });
  }

  void Eliminar(int id) async {
    await BD().EliminarUsuario(id);
    obtenerUsuario();
  }

  void ModificarUsuario(int id, String usu, String pass) {
    TextEditingController u = TextEditingController(text: usu);
    TextEditingController p = TextEditingController(text: pass);
    //print('Id:' + id.toString());

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Modificar'),
            content: SingleChildScrollView(
              //El de arriba sirve para No deformar los elemntos al sacar el teclado en pantalla
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ID: $id',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: u,
                    decoration: InputDecoration(
                      labelText: '$usu',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: p,
                    decoration: InputDecoration(
                      labelText: '$pass',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await BD().ModificarUsuario(id, u.text, p.text);
                  obtenerUsuario();
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mostrar Datos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 26, 64),
      ),
      body: usuarios.isEmpty
          ? Center(
              child: Text('Lista vacia'),
            )
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.abc_sharp),
                  title: Text(usuarios[index]['usuario']),
                  subtitle: Text(usuarios[index]['password']),
                  trailing: Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    children: [
                      IconButton(
                          onPressed: () {
                            EliminarUsuario(usuarios[index]['id'],
                                usuarios[index]['usuario']);
                          },
                          icon: Icon(Icons.delete)),
                      IconButton(
                          onPressed: () {
                            ModificarUsuario(
                                usuarios[index]['id'],
                                usuarios[index]['usuario'],
                                usuarios[index]['password']);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            EliminarUsuario(usuarios[index]['id'],
                                usuarios[index]['usuario']);
                          },
                          icon: Icon(Icons.abc)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

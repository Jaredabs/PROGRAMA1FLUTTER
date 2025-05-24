import 'package:flutter/material.dart';
import 'package:prac4/basedatos/BD.dart';

class Agregar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Agregar> {
  final TextEditingController titulo = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController realizada = TextEditingController();

  void agregar() async {
    String t = titulo.text;
    String des = descripcion.text;
    String r = realizada.text;

    if (t.isNotEmpty && des.isNotEmpty && r.isNotEmpty) {
      await BD().insertartarea(t, des, r);
      titulo.clear();
      descripcion.clear();
      realizada.clear();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Resultado'),
            content: Text('GUARDADo'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Resultado'),
            content: Text('VACIO'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda'),
        backgroundColor: const Color.fromARGB(255, 165, 170, 174),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: const Color.fromARGB(255, 232, 148, 236),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: TextField(
                        controller: titulo,
                        decoration: InputDecoration(hintText: 'Titulo'),
                      ),
                    ),
                    TextField(
                      controller: descripcion,
                      decoration: InputDecoration(hintText: 'Descripcion'),
                    ),
                    TextField(
                      controller: realizada,
                      decoration: InputDecoration(hintText: 'Realizo  0 / 1 '),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text('Agregar'),
                        onPressed: agregar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

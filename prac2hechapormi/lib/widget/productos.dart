import 'package:flutter/material.dart';
import 'package:prac2hechapormi/basedatos/BD.dart';
import 'package:prac2hechapormi/widget/MostrarDatos.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  Ventana createState() => Ventana();
}

class Ventana extends State<Productos> {
  final TextEditingController nombres = TextEditingController();
  final TextEditingController cantidades = TextEditingController();
  final TextEditingController precios = TextEditingController();
  List<Map<String, dynamic>> productoos = [];
  @override
  void initState() {
    super.initState();
    obtenerProductos();
  }

  void MostrarIva() {
    TextEditingController n = TextEditingController();
    TextEditingController c = TextEditingController();
    TextEditingController p = TextEditingController();

    int can = int.tryParse(c.text) ?? 0;
    double pre = double.tryParse(p.text) ?? 0;

    double iva = pre * 1.16;
    suma += iva;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Respuestas'),
            content: Text('iva: $iva y Total $suma'),
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
  }

  void Agregar() async {
    String n = nombres.text;
    String c = cantidades.text;
    String p = precios.text;

    int can = int.tryParse(cantidades.text) ?? 0;
    int pre = int.tryParse(precios.text) ?? 0;

    if (n.isNotEmpty && p.isNotEmpty && c.isNotEmpty) {
      await BD().insertarProducto(n, can, pre);
      nombres.clear();
      precios.clear();
      cantidades.clear();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text('Producto Agregado'),
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

  void obtenerProductos() async {
    List<Map<String, dynamic>> datos = await BD().obtenerProducto();
    setState(() {
      productoos = datos;
    });
  }

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
                    controller: nombres,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Producto:',
                    ),
                  ),
                  TextField(
                    controller: cantidades,
                    decoration: InputDecoration(
                      labelText: 'Cantidad:',
                    ),
                  ),
                  TextField(
                    controller: precios,
                    decoration: InputDecoration(
                      labelText: 'Precio:',
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
                    /*además se podrá modificar o eliminar uno de lista de los productos y un botón que me indique los productos comprados el iva y el total a pagar, la cual la mostrara como una alerta*/
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

import 'package:flutter/material.dart';
import 'package:prac2hechapormi/basedatos/BD.dart';

class Mostrardatos extends StatefulWidget {
  const Mostrardatos({super.key});

  @override
  Lista createState() => Lista();
}

double suma = 0;

class Lista extends State<Mostrardatos> {
  List<Map<String, dynamic>> productoos = [];
  @override
  void initState() {
    super.initState();
    obtenerProductos();
  }

  void obtenerProductos() async {
    List<Map<String, dynamic>> datos = await BD().obtenerProducto();
    setState(() {
      productoos = datos;
    });
  }

  void EliminarProductos(int id, String nombre) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: Text('Estas Seguro de\n Eliminar a: $nombre'),
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
    await BD().EliminarProducto(id);
    obtenerProductos();
  }

  void ModificarProductos(int id, String no, int ca, int pa) {
    TextEditingController n = TextEditingController(text: no);
    TextEditingController c = TextEditingController(text: ca.toString());
    TextEditingController p = TextEditingController(text: pa.toString());
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
                    controller: n,
                    decoration: InputDecoration(
                      labelText: 'nombre',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: c,
                    decoration: InputDecoration(
                      labelText: 'cantidad',
                    ),
                  ),
                  TextField(
                    controller: p,
                    decoration: InputDecoration(
                      labelText: 'precio',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String nombre = n.text;
                  int cantidad = int.tryParse(c.text) ?? 0;
                  int precio = int.tryParse(p.text) ?? 0;

                  await BD().ModificarProducto(id, n.text, cantidad, precio);

                  obtenerProductos();
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

  void mostrarResumenEnAlerta(BuildContext context) async {
    final db = BD();
    Map<String, dynamic> resumen = await db.obtenerResumenConIva();

    int sumaTotal = resumen['suma'];
    double iva = resumen['iva'];
    double totalConIva = resumen['total'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resumen de Productos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suma total (sin IVA): \$${sumaTotal}'),
            Text('IVA (16%): \$${iva.toStringAsFixed(2)}'),
            Text('Total con IVA: \$${totalConIva.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mostrar Datos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 26, 64),
      ),
      body: productoos.isEmpty
          ? Center(child: Text('Lista vacía'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productoos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.abc_sharp),
                        title: Text(productoos[index]['nombre']),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productoos[index]['cantidad'].toString()),
                            Text(productoos[index]['precio'].toString()),
                          ],
                        ),
                        trailing: Wrap(
                          direction: Axis.vertical,
                          spacing: 5,
                          children: [
                            IconButton(
                              onPressed: () {
                                EliminarProductos(
                                  productoos[index]['id'],
                                  productoos[index]['nombre'],
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                ModificarProductos(
                                  productoos[index]['id'],
                                  productoos[index]['nombre'],
                                  productoos[index]['cantidad'],
                                  productoos[index]['precio'],
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    mostrarResumenEnAlerta(context);
                  },
                  child: Text('Mostrar Resumen'),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}

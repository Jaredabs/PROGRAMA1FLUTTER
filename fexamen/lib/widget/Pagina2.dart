import 'package:fexamen/basedatos/BDHelper.dart';
import 'package:fexamen/widget/inicio.dart';
import 'package:flutter/material.dart';

class Pagina2 extends StatefulWidget {
  const Pagina2({super.key});

  @override
  State<StatefulWidget> createState() {
    return pa2();
  }
}

//2. mostrar la lista, pero con un btn para poder agregar el campo de cantidad
class pa2 extends State<Pagina2> {
  List<Map<String, dynamic>> cuentas = [];
  bool ventana = false;
  TextEditingController canti = TextEditingController();
  void enviarInsertar(int id, double can) async {
    //int respuesta = await BdQR().eliminarProducto(codigo);
    bool? confirmacion = await showDialog(
      context: context,
      builder: (_context) => AlertDialog(
        title: Text("ATENCION"),
        content: Text("Desea agregar una cantidad con el id:$id"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_context, true),
            child: Text("Si"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(_context),
            child: Text("No"),
          ),
        ],
      ),
    );

    if (confirmacion != null) {
      double can = double.tryParse(canti.text) ?? 0;
      int respuesta = await Bdhelper().modificarCuenta(id, can);
      if (respuesta != 0) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Agregar cantidad'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('id: $id'),
                  TextField(
                    decoration: InputDecoration(labelText: 'Cantidad'),
                    controller: canti,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    double cant = double.tryParse(canti.text) ?? 0;
                    String c = canti.text;
                    if (c.isNotEmpty) {
                      await Bdhelper().modificarCuenta(id, cant);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cantidad modificada'),
                        ),
                      );
                    }
                    setState(() {
                      obtenerCount();
                      ventana = false;
                    });
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        ).then((_) => ventana = false);

        /*showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text("ATENCION"),
            content: Text("Elemento Modificado"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_context),
                child: Text("Enterado"),
              ),
            ],
          ),
        );*/
      } else {
        showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text("ATENCION"),
            content: Text(
              "Ocurrio un error al intentar modificar el elemento con el codigo $id",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_context),
                child: Text("Enterado"),
              ),
            ],
          ),
        );
      }
    }
  }

  void initState() {
    super.initState();
    obtenerCount();
  }

  void obtenerCount() async {
    List<Map<String, dynamic>> datos = await Bdhelper().obtenerCuenta();
    setState(() {
      cuentas = datos;
    });
  }

  void cargarDatos() async {
    List<Map<String, dynamic>> valores = await Bdhelper().obtenerCuenta();
    setState(() {
      cuentas = valores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: const Color.fromARGB(255, 222, 222, 221),
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: cuentas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text("Correo: ${cuentas[index]["correo"]}"),
                              subtitle: Text(
                                  'Contraseña: ${cuentas[index]["contraseña"]}'),
                              trailing: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Text(
                                    "cantidad: ${cuentas[index]["cantidad"].toString()}",
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      enviarInsertar(
                                        cuentas[index]['id'],
                                        cuentas[index]['cantidad'],
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

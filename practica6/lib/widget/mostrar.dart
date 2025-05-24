import 'package:flutter/material.dart';
import 'package:practica6/basedatos/BDHelper.dart';

class Mostrar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Mostrar> {
  List<Map<String, dynamic>> productos = [];

  void cargarDatos() async {
    List<Map<String, dynamic>> valores = await Bdhelper().obtenerProductos();
    setState(() {
      productos = valores;
    });
  }

  void enviarEliminar(String codigo) async {
    //int respuesta = await BdQR().eliminarProducto(codigo);
    bool? confirmacion = await showDialog(
      context: context,
      builder: (_context) => AlertDialog(
        title: Text("ATENCION"),
        content: Text("Desea eliminar el producto con el codigo $codigo"),
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
      int respuesta = await Bdhelper().eliminarProducto(codigo);
      if (respuesta != 0) {
        showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text("ATENCION"),
            content: Text("Elemento Eliminado"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(_context),
                child: Text("Enterado"),
              ),
            ],
          ),
        );
        cargarDatos();
      } else {
        showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text("ATENCION"),
            content: Text(
              "Ocurrio un error al intentar eliminar el elemento con el codigo $codigo",
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
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mostrar datos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: productos.isEmpty
          ? Center(
              child: Text('No hay productos'),
            )
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Clave: ${productos[index]["codigo"]}"),
                  subtitle: Text('Nombre: ${productos[index]["nombre"]}'),
                  trailing: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text(
                        "Precio: ${productos[index]["precio"].toString()}",
                      ),
                      IconButton(
                        onPressed: () {
                          //Eliminamos el elemento seleccionado
                          enviarEliminar(productos[index]['codigo']);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

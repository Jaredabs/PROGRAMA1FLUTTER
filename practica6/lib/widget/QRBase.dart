import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
//
//
//
//import 'package:path/path.dart';
import 'package:practica6/basedatos/BDHelper.dart';
import 'package:practica6/widget/mostrar.dart';

class Qrbase extends StatefulWidget {
  const Qrbase({super.key});

  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Qrbase> {
  bool ventana = false;
  String nombre = "", precio = "";

  void mostrarDatosQR(String numeros) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Datos QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Codigo $numeros'),
              TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => nombre = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Precio'),
                onChanged: (value) => precio = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nombre.isNotEmpty && precio.isNotEmpty) {
                  double pre = double.parse(precio);
                  await Bdhelper().insertarProducto(numeros, nombre, pre);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Producto Guardado'),
                    ),
                  );
                }
                setState(() {
                  ventana = false;
                });
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    ).then((_) => ventana = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lector de QR',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //print('Datos');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mostrar()),
              );
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (ventana) return;

          final Barcode? barcode = capture.barcodes.firstOrNull;
          final String numeros =
              barcode?.rawValue ?? 'Sin código, intenta de nuevo';

          if (numeros != 'Sin código, intenta de nuevo') {
            setState(() {
              ventana = true;
            });
            mostrarDatosQR(numeros);
          }
        },
      ),
    );
  }
}

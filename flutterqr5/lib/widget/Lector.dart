import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:collection/collection.dart';

class Lector extends StatefulWidget {
  const Lector({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LectorState();
  }
}

class _LectorState extends State<Lector> {
  bool ventana = false;

  void mostrarDatosQR(String numeros) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Datos QR'),
          content: Text('Código: $numeros'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  ventana = false;
                });
                Navigator.of(context).pop();
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

import 'package:fexamen/basedatos/BDHelper.dart';
import 'package:fexamen/widget/inicio.dart';
import 'package:flutter/material.dart';

class Mostrar extends StatefulWidget {
  const Mostrar({super.key});

  @override
  State<StatefulWidget> createState() {
    return mostra();
  }
}

class mostra extends State<Mostrar> {
  List<Map<String, dynamic>> cuentas = [];
  bool ventana = false;
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
                        height: 350,
                        child: ListView.builder(
                          itemCount: cuentas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text("Correo: ${cuentas[index]["correo"]}"),
                              subtitle: Text(
                                  'Contraseña: ${cuentas[index]["contraseña"]}'),
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

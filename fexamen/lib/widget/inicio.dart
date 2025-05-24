import 'package:fexamen/basedatos/BDHelper.dart';
import 'package:fexamen/widget/crear.dart';
import 'package:fexamen/widget/mostrar.dart';
import 'package:fexamen/widget/ultimo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Inicio extends StatefulWidget {
  final String cor;
  final String pa;

  const Inicio({
    super.key,
    required this.cor,
    required this.pa,
  });
  @override
  State<StatefulWidget> createState() {
    return ini();
  }
}

class ini extends State<Inicio> {
  final TextEditingController corr = TextEditingController();
  final TextEditingController cont = TextEditingController();

  final _key = GlobalKey<FormState>();

  late String corre;
  late String conta;
  List<Map<String, dynamic>> cuentas = [];
  bool ventana = false;
  void initState() {
    super.initState();
    cargarDatos();
    conta = widget.pa;
    corre = widget.cor;
  }

  void cargarDatos() async {
    List<Map<String, dynamic>> valores = await Bdhelper().obtenerCuenta();
    setState(() {
      cuentas = valores;
    });
  }

  /*void verificar() async {
    String u = corr.text;
    String p = cont.text;
    if (u.isNotEmpty && p.isNotEmpty) {
      bool respuesta = await Bdhelper().ValidarUsuario(u, p);

      if (respuesta) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Ultimo()),
        );
      } else {
        /*showDialog(
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
        );*/
      }
    } else {
      //ALERTAS
      //ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(
      // content: Text('Error, no existe el usuario'),
      // ),
      //);

      //FIN
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EXAMEN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final route = MaterialPageRoute(
                builder: (_) => Crear(),
              );
              Navigator.push(context, route);
            },
            child: Text('Registro'),
          ),
        ],
        backgroundColor: Colors.brown,
      ),
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
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: corr,
                          decoration: InputDecoration(
                              labelText: 'Escribe el correo',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (value == null || value.isEmpty) {
                              return 'Datos vacíos';
                            } else if (!emailRegex.hasMatch(value)) {
                              return 'Correo no válido';
                            }
                          },
                        ),
                        TextField(
                          controller: cont,
                          decoration: InputDecoration(hintText: "Contraseña"),
                          inputFormatters: [
                            FilteringTextInputFormatter(
                                RegExp(r'^[a-zA-Z0-9]{1,10}'),
                                allow: true)
                          ],
                        ),
                        /*Text(
                        guardado,
                        style: TextStyle(
                          color: Color.fromARGB(255, 37, 13, 131),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),*/
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                String u = corr.text;
                                String p = cont.text;

                                bool respuesta =
                                    await Bdhelper().ValidarUsuario(u, p);

                                if (respuesta) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Ultimo()),
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
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error en validaciones'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Aceptar'),
                          ),
                        ),
                      ],
                    ),
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

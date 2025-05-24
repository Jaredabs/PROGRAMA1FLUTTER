import 'package:fexamen/basedatos/BDHelper.dart';
import 'package:fexamen/widget/inicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Crear extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ini();
  }
}

class ini extends State<Crear> {
  final TextEditingController corr = TextEditingController();
  final TextEditingController cont = TextEditingController();
  final _key = GlobalKey<FormState>();
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

  void agregar() async {
    String co = corr.text;
    String pa = cont.text;

    double can = 0.0;
    if (co.isNotEmpty && pa.isNotEmpty) {
      await Bdhelper().insertarCuenta(co, pa, 0.0);
      corr.clear();
      cont.clear();

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Inicio(
            cor: co,
            pa: pa,
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear usuario',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final route = MaterialPageRoute(
                builder: (_) => Inicio(cor: '', pa: ''),
              );
              Navigator.push(context, route);
            },
            child: Text('Regresar'),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 47, 198, 5),
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
                                String co = corr.text;
                                String pa = cont.text;

                                double can = 0.0;
                                if (co.isNotEmpty && pa.isNotEmpty) {
                                  await Bdhelper().insertarCuenta(co, pa, 0.0);
                                  corr.clear();
                                  cont.clear();

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Inicio(
                                        cor: co,
                                        pa: pa,
                                      ),
                                    ),
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
                        SizedBox(
                          height: 250,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

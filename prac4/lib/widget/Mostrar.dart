import 'package:flutter/material.dart';
import 'package:prac4/basedatos/BD.dart';

class Mostrar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Clase();
  }
}

class Clase extends State<Mostrar> {
  List<Map<String, dynamic>> tareas = [];

  @override
  void initState() {
    super.initState();
    obtenerTareas();
  }

  void obtenerTareas() async {
    final datos = await BD().obtenerdatos();
    setState(() {
      tareas = datos;
    });
  }

  void eliminarTarea(int id, String titulo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar tarea'),
        content: Text('¿Seguro que deseas eliminar "$titulo"?'),
        actions: [
          TextButton(
            onPressed: () {
              eliminar(id);
              Navigator.pop(context);
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void eliminar(int id) async {
    final db = await BD().database;
    await db.delete('tareas', where: 'id = ?', whereArgs: [id]);
    obtenerTareas();
  }

  void modificarTarea(Map<String, dynamic> tarea) {
    TextEditingController tituloCtrl = TextEditingController(
      text: tarea['titulo'],
    );
    TextEditingController descCtrl = TextEditingController(
      text: tarea['descripcion'],
    );
    TextEditingController realizadaCtrl = TextEditingController(
      text: tarea['realizada'].toString(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modificar tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: InputDecoration(hintText: 'Título'),
            ),
            TextField(
              controller: descCtrl,
              decoration: InputDecoration(hintText: 'Descripción'),
            ),
            TextField(
              controller: realizadaCtrl,
              decoration: InputDecoration(hintText: '0 o 1'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final db = await BD().database;
              await db.update(
                'tareas',
                {
                  'titulo': tituloCtrl.text,
                  'descripcion': descCtrl.text,
                  'realizada': int.tryParse(realizadaCtrl.text) ?? 0,
                },
                where: 'id = ?',
                whereArgs: [tarea['id']],
              );
              obtenerTareas();
              Navigator.pop(context);
            },
            child: Text('Guardar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
        backgroundColor: const Color.fromARGB(255, 185, 203, 71),
      ),
      body: tareas.isEmpty
          ? Center(child: Text('No hay tareas registradas'))
          : ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                final realizada =
                    tarea['realizada'] == 1 ? ' Realizada' : ' No realizada';

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(tarea['titulo']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(tarea['descripcion']), Text(realizada)],
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => modificarTarea(tarea),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              eliminarTarea(tarea['id'], tarea['titulo']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

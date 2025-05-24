import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BD {
  static final BD _instance = BD._internal();
  factory BD() => _instance;
  BD._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'productos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          Create table productos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          cantidad int NOT NULL,
          precio int NOT NULL
          )

          ''');
      },
    );
  }

  Future<int> insertarProducto(String no, int ca, int pre) async {
    final db = await database;
    return await db.insert('productos', {
      'nombre': no,
      'cantidad': ca,
      'precio': pre,
    });
  }

  Future<Map<String, dynamic>> obtenerResumenConIva() async {
    final db = await database;
    List<Map<String, dynamic>> productos = await db.query('productos');

    int sumaTotal = 0;

    for (var producto in productos) {
      int cantidad = producto['cantidad'];
      int precio = producto['precio'];
      sumaTotal += cantidad * precio;
    }

    double iva = sumaTotal * 0.16;
    double totalConIva = sumaTotal + iva;

    return {
      'suma': sumaTotal,
      'iva': iva,
      'total': totalConIva,
    };
  }

  Future<List<Map<String, dynamic>>> obtenerProducto() async {
    final db = await database;
    return await db.query('productos');
    //query = seleccionar datos
  }

  Future<bool> ValidarProducto(String no, int ca, int pre) async {
    final db = await database;
    List<Map<String, dynamic>> respuesta = await db.query(
      'productos',
      where: 'nombre = ? and cantidad = ? and precio = ?',
      whereArgs: [no, ca, pre],
    );
    return respuesta.isNotEmpty;
  }

  Future<int> EliminarProducto(int id) async {
    final db = await database;
    return await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> ModificarProducto(int id, String no, int ca, int pre) async {
    final db = await database;
    return await db.update(
        'productos', {'nombre': no, 'cantidad': ca, 'precio': pre},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> obtenerNombresDeProductos() async {
    final db = await database;
    final productos = await db.query('productos', columns: ['nombre']);
    return productos.map((producto) => producto['nombre'] as String).toList();
  }
}

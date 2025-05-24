import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Bdhelper {
  static final Bdhelper _instance = Bdhelper._internal();
  factory Bdhelper() => _instance;
  Bdhelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'Cuentas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          Create table Cuenta(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          correo TEXT  NOT NULL,
          contraseña TEXT NOT NULL,
          cantidad Real
          )

          ''');
      },
    );
  }

  Future<int> insertarCuenta(
      String Correo, String Contrasena, double cantidad) async {
    final db = await database;
    return await db.insert('Cuenta', {
      'correo': Correo,
      'contraseña': Contrasena,
      'cantidad': cantidad,
    });
  }

  Future<List<Map<String, dynamic>>> obtenerCuenta() async {
    final db = await database;
    return await db.query('Cuenta');
    //query = seleccionar datos
  }

  Future<int> eliminarCuenta(int id) async {
    final db = await database;
    return await db.delete('Cuenta', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> modificarCuenta(int id, double can) async {
    final db = await database;
    return await db.update(
        'Cuenta',
        {
          'cantidad': can,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<bool> ValidarUsuario(String nu, String np) async {
    final db = await database;
    List<Map<String, dynamic>> respuesta = await db.query(
      'Cuenta',
      where: 'correo = ? and contraseña = ?',
      whereArgs: [nu, np],
    );
    return respuesta.isNotEmpty;
  }
}

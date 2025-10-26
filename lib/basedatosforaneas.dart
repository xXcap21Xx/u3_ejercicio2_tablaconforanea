import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/citaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/consultaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/personaModelo.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "ejercicio2.db"),
      version: 1,
      onConfigure: (db) {
        return db.execute("PRAGMA foreign_key = ON");
      },
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE persona(idPersona INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, telefono TEXT)",
        );
        await db.execute(
          "CREATE TABLE cita(idCita INTEGER PRIMARY KEY AUTOINCREMENT, lugar TEXT, fecha TEXT, hora TEXT, anotaciones TEXT, idPersona INTEGER,FOREIGN KEY (idPersona) REFERENCES persona(idPersona) ON DELETE CASCADE ON UPDATE CASCADE)",
        );
      },
    );
  }

  static Future<int> insertarPersona(Persona p) async {
    Database base = await _conectarDB();
    return base.insert("persona", p.toJSON());
  }

  static Future<int> insertarCita(Cita c) async {
    Database base = await _conectarDB();
    return base.insert("cita", c.toJSON());
  }

  static Future<int> eliminarPersona(int idPersona) async {
    Database base = await _conectarDB();
    return base.delete("persona", where: "idPersona=?", whereArgs: [idPersona]);
  }

  static Future<int> eliminarCita(int idCita) async {
    Database base = await _conectarDB();
    return base.delete("cita", where: "idCita=?", whereArgs: [idCita]);
  }

  static Future<List<Persona>> mostrarPersona() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("persona");
    return List.generate(temp.length, (contador) {
      return Persona(
        idPersona: temp[contador]['idPersona'],
        nombre: temp[contador]['nombre'],
        telefono: temp[contador]['telefono'],
      );
    });
  }

  static Future<List<Cita>> mostrarCita() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("cita");

    return List.generate(temp.length, (contador) {
      return Cita(
        idCita: temp[contador]['idCita'],
        lugar: temp[contador]['lugar'],
        fecha: temp[contador]['fecha'],
        hora: temp[contador]['hora'],
        anotaciones: temp[contador]['anotaciones'],
        idPersona: temp[contador]['idPersona'],
      );
    });
  }

  static Future<int> actualizarPersona(Persona p) async {
    Database base = await _conectarDB();
    return base.update(
      "persona",
      p.toJSON(),
      where: "idPersona = ?",
      whereArgs: [p.idPersona],
    );
  }

  static Future<int> actualizarCita(Cita a) async {
    Database base = await _conectarDB();
    return base.update(
      "cita",
      a.toJSON(),
      where: "idCita = ?",
      whereArgs: [a.idCita],
    );
  }

  static Future<List<consultaModelo>> getAllCitas() async {
    Database base = await _conectarDB();
    final List<Map<String, dynamic>> resultado = await base.rawQuery('''
      SELECT c.*, p.nombre as nombrePersona
      FROM cita c
      INNER JOIN persona p ON c.idPersona = p.idPersona
      ORDER BY c.fecha DESC, c.hora DESC
    ''');
    return resultado
        .map(
          (map) => consultaModelo(
            idCita: map['idCita'],
            lugar: map['lugar'],
            fecha: map['fecha'],
            hora: map['hora'],
            anotaciones: map['anotaciones'],
            nombrePersona: map['nombrePersona'],
          ),
        )
        .toList();
  }

  static Future<List<consultaModelo>> getCitaHoy() async {
    Database base = await _conectarDB();

    String hoy = DateTime.now().toIso8601String().split('T').first;

    final List<Map<String, dynamic>> resultado = await base.rawQuery(
      '''
      SELECT c.idCita, c.lugar, c.fecha, c.hora, c.anotaciones, p.nombre as nombrePersona
      FROM cita c
      INNER JOIN persona p ON c.idPersona = p.idPersona
      WHERE c.fecha >= ?
      ORDER BY c.fecha ASC, c.hora ASC
    ''',
      [hoy],
    );

    return resultado.map((map) {
      return consultaModelo(
        idCita: map['idCita'],
        lugar: map['lugar'],
        fecha: map['fecha'],
        hora: map['hora'],
        anotaciones: map['anotaciones'],
        nombrePersona: map['nombrePersona'],
      );
    }).toList();
  }
  static Future<Persona?> getPersonaById(int id) async {
    Database base = await _conectarDB();
    final List<Map<String, dynamic>> maps = await base.query(
      'persona',
      where: 'idPersona = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Persona.fromJSON(maps.first);
    }
    return null;
  }
}

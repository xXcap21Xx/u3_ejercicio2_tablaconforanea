import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablaconforanea/basedatosforaneas.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/personaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/formularios/formularioPersona.dart';

class ListaPersonas extends StatefulWidget {
  const ListaPersonas({super.key});

  @override
  State<ListaPersonas> createState() => _ListaPersonasState();
}

class _ListaPersonasState extends State<ListaPersonas> {
  late Future<List<Persona>> _listaPersonas;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _listaPersonas = DB.mostrarPersona();
    });
  }

  void _navegarAFormulario([Persona? persona]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioPersona(persona: persona)),
    );

    if (resultado == true) {
      _actualizarLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Persona>>(
        future: _listaPersonas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No tienes personas registradas.\n¡Agrega uno!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }
          final personas = snapshot.data!;
          return ListView.builder(
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              return Card(
                child: ListTile(
                  title: Text(persona.nombre),
                  subtitle: Text(persona.telefono),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navegarAFormulario(persona),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarPersona(persona.idPersona!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarAFormulario(),
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void _eliminarPersona(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("¿Seguro que quieres eliminar a esta persona?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                DB.eliminarPersona(id).then((_) {
                  _actualizarLista();
                });
                Navigator.of(context).pop();
              },
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

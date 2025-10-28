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
          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar los datos"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Aún no hay nadie aquí",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Presiona el botón '+' para añadir tu primer amigo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }



          final personas = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.only(top: 8,bottom: 80),
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300,width: 1),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(persona.nombre.isNotEmpty ? persona.nombre[0] : '?',
                    style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),
                    ),
                  ),
                  title: Text(persona.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(persona.telefono, style: TextStyle(color: Colors.grey.shade600),
                  ),
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

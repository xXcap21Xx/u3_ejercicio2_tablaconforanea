import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablaconforanea/basedatosforaneas.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/consultaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/formularios/formularioCita.dart';

class ventanaCita extends StatefulWidget {
  const ventanaCita({super.key});

  @override
  State<ventanaCita> createState() => _ventanaCitaState();
}

class _ventanaCitaState extends State<ventanaCita> {
  late Future<List<consultaModelo>> _listaCita;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _listaCita = DB.getAllCitas();
    });
  }

  void _navegarAFormulario([consultaModelo? cita]) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioCita(citaEditar: cita)),
    );
    if (resultado == true) {
      _actualizarLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<consultaModelo>>(
        future: _listaCita,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar las citas"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No hay citas agendadas",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Presiona el botón '+' para crear una nueva cita.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          final citas = snapshot.data!;
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(20, 12, 12, 12),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 36,
                      ),
                    ],
                  ),
                  title: Text(
                    cita.lugar,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Con: ${cita.nombrePersona}\n${cita.fecha} - ${cita.hora}",
                    style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _navegarAFormulario(cita);
                      } else if (value == 'delete') {
                        _eliminarCita(cita.idCita);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined, color: Colors.blue),
                          title: Text('Editar'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline, color: Colors.red),
                          title: Text('Eliminar'),
                        ),
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

  void _eliminarCita(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("¿Estás seguro de que quieres eliminar esta cita?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                DB.eliminarCita(id).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cita eliminada correctamente')),
                  );
                  _actualizarLista();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

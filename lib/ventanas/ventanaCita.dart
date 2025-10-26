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
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No hay citas registradas.",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          final citas = snapshot.data!;
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: Icon(Icons.event_note, color: Colors.cyan, size: 40),
                  title: Text(
                    cita.lugar,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Con: ${cita.nombrePersona}\n${cita.anotaciones}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${cita.fecha}\n${cita.hora}",
                        textAlign: TextAlign.right,
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _navegarAFormulario(cita);
                          } else if (value == 'delete') {
                            _eliminarCita(cita.idCita);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: Text('Eliminar'),
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => _navegarAFormulario(),
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

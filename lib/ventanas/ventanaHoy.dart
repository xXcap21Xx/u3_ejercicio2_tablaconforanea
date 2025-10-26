import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablaconforanea/basedatosforaneas.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/consultaModelo.dart';

class ventanaHoy extends StatefulWidget {
  const ventanaHoy({super.key});

  @override
  State<ventanaHoy> createState() => _ventanaHoyState();
}

class _ventanaHoyState extends State<ventanaHoy> {
  late Future<List<consultaModelo>> _listaProximasCitas;

  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  void _actualizarLista() {
    setState(() {
      _listaProximasCitas = DB.getCitaHoy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _actualizarLista();
        },
        child: FutureBuilder<List<consultaModelo>>(
          future: _listaProximasCitas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: ListView(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "¡Estás libre!\nNo tienes citas próximas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
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
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.today, color: Colors.cyan, size: 40),
                    title: Text(
                      cita.lugar,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Con: ${cita.nombrePersona}"),
                    trailing: Text(
                      "${cita.fecha}\n${cita.hora}",
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

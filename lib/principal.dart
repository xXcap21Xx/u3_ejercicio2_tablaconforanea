import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablaconforanea/ventanas/ventanaHoy.dart';
import 'package:u3_ejercicio2_tablaconforanea/ventanas/ventanaCita.dart';
import 'package:u3_ejercicio2_tablaconforanea/ventanas/listaPersonas.dart';

class App02u3 extends StatefulWidget {
  const App02u3({super.key});

  @override
  State<App02u3> createState() => _App02u3State();
}

class _App02u3State extends State<App02u3> {
  int _index = 0;

  final List<Widget> _ventanas = [ListaPersonas(), ventanaCita(), ventanaHoy()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de Citas/Eventos"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: _ventanas[_index],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Image.asset("assets/img5.png", width: 80),
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mi Agenda",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            _itemDrawer(0, Icons.people, "Personas"),
            _itemDrawer(1, Icons.book_online, "Citas"),
            Divider(),
            _itemDrawer(2, Icons.today, "Mostrar Citas (Hoy)"),
          ],
        ),
      ),
    );
  }

  Widget _itemDrawer(int indice, IconData icono, String text) {
    return ListTile(
      onTap: () {
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        icono,
        size: 30,
        color: _index == indice ? Colors.cyan : Colors.grey,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: _index == indice ? Colors.cyan : Colors.black87,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:u3_ejercicio2_tablaconforanea/basedatosforaneas.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/personaModelo.dart';

class FormularioPersona extends StatefulWidget {
  final Persona? persona;
  const FormularioPersona({super.key, this.persona});

  @override
  State<FormularioPersona> createState() => _FormularioPersonaState();
}

class _FormularioPersonaState extends State<FormularioPersona> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreControlador;
  late TextEditingController _telControlador;
  bool _esEditar = false;

  @override
  void initState() {
    super.initState();
    _nombreControlador = TextEditingController();
    _telControlador = TextEditingController();

    if (widget.persona != null) {
      _esEditar = true;
      _nombreControlador.text = widget.persona!.nombre;
      _telControlador.text = widget.persona!.telefono;
    }
  }

  @override
  void dispose() {
    _nombreControlador.dispose();
    _telControlador.dispose();
    super.dispose();
  }

  void _guardarPersona() async {
    if (_formKey.currentState!.validate()) {
      if (_esEditar) {
        final personaActualizada = Persona(
          idPersona: widget.persona!.idPersona,
          nombre: _nombreControlador.text,
          telefono: _telControlador.text,
        );
        await DB.actualizarPersona(personaActualizada);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Persona actualizada con éxito!')),
        );
      } else {
        final nuevaPersona = Persona(
          idPersona: null,
          nombre: _nombreControlador.text,
          telefono: _telControlador.text,
        );
        await DB.insertarPersona(nuevaPersona);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('¡Persona guardada con éxito!')));
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEditar ? 'Editar Persona' : 'Añadir Persona'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreControlador,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telControlador,
                decoration: InputDecoration(
                  labelText: 'Telefono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduce un numero de telefono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardarPersona,
                icon: Icon(Icons.save),
                label: Text(_esEditar ? 'Actualizar' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

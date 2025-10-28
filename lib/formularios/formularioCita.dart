import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:u3_ejercicio2_tablaconforanea/basedatosforaneas.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/citaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/consultaModelo.dart';
import 'package:u3_ejercicio2_tablaconforanea/modelos/personaModelo.dart';

class FormularioCita extends StatefulWidget {
  final Cita? cita;
  final consultaModelo? citaEditar;
  final int? idPersona;

  const FormularioCita({super.key, this.cita, this.idPersona, this.citaEditar});

  @override
  State<FormularioCita> createState() => _FormularioCitaState();
}

class _FormularioCitaState extends State<FormularioCita> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _lugarController;
  late TextEditingController _anotacionesController;
  late TextEditingController _fechaController;
  late TextEditingController _horaController;

  bool _esEditar = false;
  Future<List<Persona>>? _personasFuture;
  Persona? _personaSeleccionada;
  bool _depCargada = false;

  @override
  void initState() {
    super.initState();
    _lugarController = TextEditingController();
    _anotacionesController = TextEditingController();
    _fechaController = TextEditingController();
    _horaController = TextEditingController();

    _esEditar = widget.citaEditar != null;

    if (_esEditar) {
      final cita = widget.citaEditar!;
      _lugarController.text = cita.lugar;
      _anotacionesController.text = cita.anotaciones;
      _fechaController.text = cita.fecha;
      _horaController.text = cita.hora;
    } else {
      _fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    _personasFuture = _cargarPersonas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_depCargada) {
      if (!_esEditar) {
        _horaController.text = TimeOfDay.now().format(context);
      }
      _depCargada = true;
    }
  }

  Future<List<Persona>> _cargarPersonas() async {
    final personas = await DB.mostrarPersona();
    if (_esEditar) {
      final idPersonaDeCita = widget.citaEditar!.idPersona;
      try {
        _personaSeleccionada = personas.firstWhere(
          (p) => p.idPersona == idPersonaDeCita,
        );
      } catch (e) {
        _personaSeleccionada = null;
      }
    }
    return personas;
  }

  Future<void> _seleccionarFecha() async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (fecha != null) {
      setState(() {
        _fechaController.text = DateFormat('yyyy-MM-dd').format(fecha);
      });
    }
  }

  Future<void> _seleccionarHora() async {
    TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _horaController.text = hora.format(context);
      });
    }
  }

  void _guardarCita() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_personaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Debes seleccionar una persona.')),
      );
      return;
    }

    final int? personaId = _personaSeleccionada!.idPersona;

    if (personaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: La persona seleccionada no es válida.')),
      );
      return;
    }
    final citaModel = Cita(
      idCita: _esEditar ? widget.citaEditar!.idCita : null,
      lugar: _lugarController.text,
      fecha: _fechaController.text,
      hora: _horaController.text,
      anotaciones: _anotacionesController.text,
      idPersona: personaId,
    );
    if (_esEditar) {
      await DB.actualizarCita(citaModel);
    } else {
      await DB.insertarCita(citaModel);
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEditar ? 'Editar Cita' : 'Nueva Cita'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FutureBuilder<List<Persona>>(
                  future: _personasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(
                        "No hay personas registradas. Añade una primero.",
                      );
                    }

                    final personas = snapshot.data!;
                    return DropdownButtonFormField<Persona>(
                      initialValue: _personaSeleccionada,
                      hint: Text('Seleccionar persona'),
                      items: personas.map((Persona persona) {
                        return DropdownMenuItem<Persona>(
                          value: persona,
                          child: Text(persona.nombre),
                        );
                      }).toList(),
                      onChanged: (Persona? newValue) {
                        setState(() {
                          _personaSeleccionada = newValue;
                        });
                      },
                      validator: (value) => value == null
                          ? 'Debes seleccionar una persona'
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_search),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _lugarController,
                  decoration: InputDecoration(
                    labelText: 'Lugar',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Introduce un lugar' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fechaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _seleccionarFecha,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _horaController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Hora',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: _seleccionarHora,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _anotacionesController,
                  decoration: InputDecoration(
                    labelText: 'Anotaciones',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _guardarCita,
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
      ),
    );
  }
}

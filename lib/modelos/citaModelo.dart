class Cita{
  int? idCita;
  String lugar;
  String fecha;
  String hora;
  String anotaciones;
  int idPersona;

  Cita({
    this.idCita,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.anotaciones,
    required this.idPersona,
});

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = {
      'lugar': lugar,
      'fecha': fecha,
      'hora': hora,
      'anotaciones': anotaciones,
      'idPersona': idPersona,
    };
    if (idCita != null) {
      data['idCita'] = idCita;
    }
    return data;
  }
}

class consultaModelo {
  final int idCita;
  final String lugar;
  final String fecha;
  final String hora;
  final String anotaciones;
  final String nombrePersona;

  consultaModelo({
    required this.idCita,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.anotaciones,
    required this.nombrePersona,
  });

  Map<String, dynamic> toJSON(){
    return{
      'idCita': idCita,
      'lugar': lugar,
      'fecha': fecha,
      'hora': hora,
      'anotaciones': anotaciones,
      'nombrePersona': nombrePersona,
    };
  }
}

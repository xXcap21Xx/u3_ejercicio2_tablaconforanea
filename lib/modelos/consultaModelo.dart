class consultaModelo {
  final int idCita;
  final String lugar;
  final String fecha;
  final String hora;
  final String anotaciones;
  final int idPersona;
  final String nombrePersona;

  consultaModelo({
    required this.idCita,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.anotaciones,
    required this.idPersona,
    required this.nombrePersona,
  });

  Map<String, dynamic> toJSON() {
    return {
      'idCita': idCita,
      'lugar': lugar,
      'fecha': fecha,
      'hora': hora,
      'anotaciones': anotaciones,
      'nombrePersona': nombrePersona,
    };
  }

  factory consultaModelo.fromJSON(Map<String, dynamic> json) {
    return consultaModelo(
      idCita: json['idCita'] as int,
      lugar: json['lugar'] as String,
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      anotaciones: json['anotaciones'] as String,
      idPersona: json['idPersona'] as int,
      nombrePersona: json['nombrePersona'] as String,
    );
  }
}

class Persona {
  int? idPersona;
  String nombre;
  String telefono;

  Persona({
    this.idPersona,
    required this.nombre,
    required this.telefono,
  });

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'telefono': telefono,
    };
    if (idPersona != null) {
      data['idPersona'] = idPersona;
    }
    return data;
  }

  factory Persona.fromJSON(Map<String, dynamic> json) {
    return Persona(
      idPersona: json['idPersona'],
      nombre: json['nombre'],
      telefono: json['telefono'].toString(),
    );
  }
}

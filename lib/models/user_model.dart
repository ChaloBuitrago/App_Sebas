class UserModel {
  final String nombre;
  final String identifier;
  final double montoPrestamo;
  final double tasaInteres;
  final DateTime fechaPrestamo;
  final String notas;

  UserModel({
    required this.nombre,
    required this.identifier,
    required this.montoPrestamo,
    required this.tasaInteres,
    required this.fechaPrestamo,
    required this.notas,
  });

  void operator [](String other) {}
}

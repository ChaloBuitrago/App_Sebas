class LoanModel {
  int? id;
  int userId;
  double monto;
  String fechaInicio;
  String periodicidad; // diario / semanal / mensual
  double tasa;
  String? createdAt;

  LoanModel({
    this.id,
    required this.userId,
    required this.monto,
    required this.fechaInicio,
    required this.periodicidad,
    required this.tasa,
    this.createdAt,
  });

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'],
      userId: map['userId'],
      monto: map['monto'],
      fechaInicio: map['fechaInicio'],
      periodicidad: map['periodicidad'],
      tasa: map['tasa'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'monto': monto,
      'fechaInicio': fechaInicio,
      'periodicidad': periodicidad,
      'tasa': tasa,
      'createdAt': createdAt,
    };
  }
}

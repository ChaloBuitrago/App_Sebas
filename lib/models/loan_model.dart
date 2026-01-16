class LoanModel {
  int? id;
  int userId;
  double monto;
  String fechaInicio;
  String periodicidad; // diario / semanal / mensual
  double tasa;
  String? createdAt;
  String? mensajeRecordatorio;

  LoanModel({
    this.id,
    required this.userId,
    required this.monto,
    required this.fechaInicio,
    required this.periodicidad,
    required this.tasa,
    this.createdAt,
    this.mensajeRecordatorio,
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
      mensajeRecordatorio: map['mensajeRecordatorio'],
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
      'mensajeRecordatorio': mensajeRecordatorio,
    };
  }



  DateTime calcularProximaFecha() {
    DateTime inicio = DateTime.parse(fechaInicio);

    switch (periodicidad.toLowerCase()){
      case 'diario':
        return inicio.add(Duration(days: 1));
      case 'semanal':
        return inicio.add(Duration(days: 7));
      case 'mensual':
        return DateTime(inicio.year, inicio.month + 1, inicio.day);
      default:
        return inicio;
    }
  }

}

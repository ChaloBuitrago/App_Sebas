class UserModel {
  final int? id;
  final String identifier;
  final String nombre;
  final String usuario;
  final String? email;
  final String password;
  final String? phone;
  final String status;
  final String? createdAt;
  final String role;

  UserModel({
    this.id,
    required this.identifier,
    required this.nombre,
    required this.usuario,
    this.email,
    this.phone,
    required this.password,
    required this.status,
    required this.role,
    this.createdAt,

  });

  /// Crear objeto desde un Map (BD → Modelo)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    print('[DEBUG fromMap] $map'); // 👀 imprime el resultado del query en consola

    return UserModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      identifier: map['identifier']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      usuario: map['usuario']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
      status: map['status']?.toString() ?? 'active', // 👈 valor por defecto
      createdAt: map['createdAt']?.toString() ?? '', // 👈 puede ser vacío
    );
  }

  /// Convertir objeto a Map (Modelo → BD)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identifier': identifier,
      'nombre': nombre,
      'usuario': usuario,
      'password': password,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'createdAt': createdAt,
    };
  }

  /// 🔹 Método copyWith para actualizar solo algunos campos
  UserModel copyWith({
    int? id,
    String? identifier,
    String? nombre,
    String? usuario,
    String? email,
    String? password,
    String? phone,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      identifier: identifier ?? this.identifier,
      nombre: nombre ?? this.nombre,
      usuario: usuario ?? this.usuario,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status,
      createdAt: createdAt,
    );
  }
}


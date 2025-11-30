class UserModel {
  final int id;
  final String identifier;
  String nombre;
  final String usuario;
  String email;
  String password;
  String phone;
  final String role;

  UserModel({
    required this.id,
    required this.identifier,
    required this.nombre,
    required this.usuario,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      identifier: map['identifier'],
      nombre: map['nombre'],
      usuario: map['usuario'],
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'],
    );
  }

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
    };
  }
}



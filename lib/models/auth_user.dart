class AuthUser {
  final int? id;
  final String identifier;
  final String nombre;
  final String usuario;
  final String? email;
  final String password;
  final String role;
  final String? createdAt;

  AuthUser({
    this.id,
    required this.identifier,
    required this.nombre,
    required this.usuario,
    this.email,
    required this.password,
    required this.role,
    this.createdAt,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id'] as int?,
      identifier: map['identifier'] as String,
      nombre: map['nombre'] as String,
      usuario: map['usuario'] as String,
      email: map['email'] as String?,
      password: map['password'] as String,
      role: map['role'] as String,
      createdAt: map['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identifier': identifier,
      'nombre': nombre,
      'usuario': usuario,
      'email': email,
      'password': password,
      'role': role,
      'createdAt': createdAt,
    };
  }
}



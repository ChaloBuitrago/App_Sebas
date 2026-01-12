import 'package:flutter/material.dart';
import '../../../screens/login_screen.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../services/loan_service.dart';

class DashboardCliente extends StatefulWidget {
  const DashboardCliente({super.key});

  @override
  State<DashboardCliente> createState() => _DashboardClienteState();
}

class _DashboardClienteState extends State<DashboardCliente> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> prestamos = [];

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print('[DASHBOARD CLIENTE] initState ejecutado');
    cargarDatosCliente();
  }

  Future<void> cargarDatosCliente() async {
    final user = await AuthService().getLoggedUser(); // Guardamos sesión luego
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario no autenticado, vuelve a iniciar sesión")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final loans = await LoanService().getLoansByUser(user.id!);

    setState(() {
      userData = user.toMap();
      prestamos = loans;
    });
    print('[DASHBOARD CLIENTE] Datos recibidos: $prestamos');
  }


  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Cargando datos del cliente..."),
            ],
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Cliente'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () {
              AuthService().logout(); // Limpiar sesión en memoria
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false, // elimina todo el stack de navegación
              );
            }
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildPrestamosActivos(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              userData!["nombre"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Usuario: ${userData!["usuario"]}"),
            Text("Email: ${userData!["email"] ?? "No registrado"}"),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text("Cambiar contraseña"),
              onPressed: () async {
                final nuevaPass = _passwordController.text.trim();
                if (nuevaPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("La nueva contraseña no puede estar vacía")),
                  );
                  return;
                }

                final auth = AuthService();
                final hashed = auth.hashPassword(nuevaPass);

                await UserService().updateUserPassword(userData!["id"], hashed);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Contraseña actualizada exitosamente")),
                  );
                _passwordController.clear();
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrestamosActivos() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Préstamos Activos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (prestamos.isEmpty)
              const Text("No tienes préstamos activos"),

            for (var p in prestamos)
              ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.green),
                title: Text("Monto: \$${p['amount']}"),
                subtitle: Text("Interés: ${p['interest']}%"),
                trailing: Text("Inicio: ${p['startDate']}"),
              ),
          ],
        ),
      ),
    );
  }
}


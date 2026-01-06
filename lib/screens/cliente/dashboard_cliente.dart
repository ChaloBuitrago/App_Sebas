import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    cargarDatosCliente();
  }

  Future<void> cargarDatosCliente() async {
    final user = await AuthService().getLoggedUser(); // Guardamos sesión luego
    if (user == null) return;

    final loans = await LoanService().getLoansByUser(user.id!);

    setState(() {
      userData = user.toMap();
      prestamos = loans;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Cliente'),
        backgroundColor: Colors.green,
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
              onPressed: () {
                Navigator.pushNamed(context, "/cambiarPassword");
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


import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'cliente_profile_screen.dart';
import 'cliente_password_screen.dart';
import 'cliente_cuentas_screen.dart';

class DashboardCliente extends StatelessWidget {
  final auth = AuthService();

  DashboardCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser; // Usuario que inició sesión

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Cliente'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hola ${user?.username ?? ''} 👋",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Tarjeta 1 → Información personal
            _MenuCard(
              title: "Mi Perfil",
              icon: Icons.person,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ClienteProfileScreen(user: user!)),
                );
              },
            ),

            const SizedBox(height: 15),

            // Tarjeta 2 → Cuentas o movimientos
            _MenuCard(
              title: "Mis Cuentas / Movimientos",
              icon: Icons.list_alt,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ClienteCuentasScreen()),
                );
              },
            ),

            const SizedBox(height: 15),

            // Tarjeta 3 → Cambiar contraseña
            _MenuCard(
              title: "Cambiar Contraseña",
              icon: Icons.lock,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ClientePasswordScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final void Function() onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

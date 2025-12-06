import 'package:flutter/material.dart';
import 'gestionar_usuarios_screen.dart';
import 'usuarios/user_list_screen.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildAdminCard(
              context,
              title: "Agregar Usuario",
              icon: Icons.person_add,
              route: "/addUser",
            ),

            // 🔵 NUEVA OPCIÓN AÑADIDA AQUÍ
            _buildAdminCard(
              context,
              title: "Gestionar Usuarios",
              icon: Icons.group,
              route: "/gestionarUsuarios",
            ),

            // 🔵 OPCIÓN PARA CAMBIAR CONTRASEÑA
            _buildAdminCard(
              context,
              title: "Cambiar mi contraseña",
              icon: Icons.lock_reset,
              route: "/cambiarPassword",
            ),

            _buildAdminCard(
              context,
              title: "Pagos Pendientes",
              icon: Icons.warning,
              route: "/pagosPendientes",
            ),
            _buildAdminCard(
              context,
              title: "Préstamos Activos",
              icon: Icons.attach_money,
              route: "/prestamosActivos",
            ),
            _buildAdminCard(
                context,
                title: "Crear Préstamo",
                icon: Icons.add_card,
                route: "/crearPrestamo",
            ),
            _buildAdminCard(
              context,
              title: "Reportes Financieros",
              icon: Icons.bar_chart,
              route: "/reportesFinancieros",
            ),
            _buildAdminCard(
              context,
              title: "Cerrar Sesión",
              icon: Icons.logout,
              route: "/cerrarSesion",
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAdminCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required String route,
      }) {
      return InkWell(
        onTap:() => Navigator.pushNamed(context, route),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow:[
              BoxShadow( color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(icon, size: 50, color: Colors.blueAccent),
                const SizedBox(height: 12),
                Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                ),
              ],
          ),

      )
      );
  }
}
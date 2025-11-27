// lib/screens/admin/loans/pagos_pendientes_screen.dart
import 'package:flutter/material.dart';

class PagosPendientesScreen extends StatelessWidget {
  const PagosPendientesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> pagos = const [
    {
      "usuario": "Carlos Gómez",
      "monto": 150000,
      "fecha": "2025-11-30",
      "prestamoId": 1
    },
    {
      "usuario": "María López",
      "monto": 220000,
      "fecha": "2025-12-02",
      "prestamoId": 2
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos Pendientes'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pagos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = pagos[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                item["usuario"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Fecha límite: ${item["fecha"]}"),
              trailing: Text(
                "\$${item["monto"]}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Abrir detalles del préstamo ID ${item['prestamoId']}"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}




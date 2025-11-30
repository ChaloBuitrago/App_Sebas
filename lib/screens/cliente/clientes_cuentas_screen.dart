import 'package:flutter/material.dart';

class ClienteCuentasScreen extends StatelessWidget {
  const ClienteCuentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Reemplazar con datos desde SQLite cuando integremos movimientos reales
    final List<Map<String, dynamic>> cuentas = [
      {"titulo": "Pago de servicio", "fecha": "2025-01-02", "valor": 45000},
      {"titulo": "Consumo mensual", "fecha": "2025-01-15", "valor": 78000},
      {"titulo": "Pago atrasado", "fecha": "2025-02-05", "valor": 35000},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Movimientos"),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: cuentas.length,
        itemBuilder: (_, i) {
          final item = cuentas[i];
          return Card(
            child: ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(item["titulo"]),
              subtitle: Text("Fecha: ${item['fecha']}"),
              trailing: Text(
                "\$${item['valor']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
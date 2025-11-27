import 'package:flutter/material.dart';

class DashboardCliente extends StatelessWidget {
  const DashboardCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel del Cliente'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Bienvenido Cliente 🧍‍♂️',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

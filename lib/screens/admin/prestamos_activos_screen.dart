import 'package:flutter/material.dart';

class PrestamosActivosScreen extends StatelessWidget {
  const PrestamosActivosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Préstamos Activos'),
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: true,
        ),
        body: const Center(
          child: Text(
            'Aquí aparecerá la lista de préstamos activos',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}


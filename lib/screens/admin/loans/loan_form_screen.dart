import 'package:flutter/material.dart';

class LoanFormScreen extends StatefulWidget {
  final Map? loanData; // Para editar, si llega algo

  const LoanFormScreen({Key? key, this.loanData}) : super(key: key);

  @override
  _LoanFormScreenState createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  final TextEditingController montoController = TextEditingController();
  final TextEditingController interesController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.loanData != null) {
      montoController.text = widget.loanData!["monto"].toString();
      interesController.text = widget.loanData!["interes"].toString();
      usuarioController.text = widget.loanData!["usuario"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.loanData == null
            ? "Crear Préstamo"
            : "Editar Préstamo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monto del préstamo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: interesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Interés (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: guardarPrestamo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: const Text(
                "Guardar",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  void guardarPrestamo() {
    // Aquí luego conectamos SQLite local o Firestore
    Navigator.pop(context, true);
  }
}

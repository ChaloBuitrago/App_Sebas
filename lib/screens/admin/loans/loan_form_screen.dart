import 'package:flutter/material.dart';
import 'package:src/services/database_helper.dart';

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
      montoController.text = widget.loanData!["amount"].toString();
      interesController.text = widget.loanData!["interest"].toString();
      usuarioController.text = widget.loanData!["userName"];
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

  void guardarPrestamo() async {
    if (widget.loanData == null) {
      //Crear nuevo préstamo
      await DatabaseHelper.instance.insertLoan({
        "userId": 1, // aquí deberías pasar el id del usuario
        "amount": double.parse(montoController.text),
        "interest": double.parse(interesController.text),
        "startDate": DateTime.now().toString(),
        "status": "activo",
        "periodicidad": "mensual",
        "customMessage": "Recordatorio de pago",
        "notes": "Préstamo creado desde formulario",
        "createdAt": DateTime.now().toString(),
      });
    } else {
      // Editar préstamo exisente
      await DatabaseHelper.instance.updateLoan(
          widget.loanData!["id"], // primer argumento: id del préstamo
          {
            "userId": widget.loanData!["userId"],
            "amount": double.parse(montoController.text),
            "interest": double.parse(interesController.text),
            "startDate": widget.loanData!["startDate"],
            "status": widget.loanData!["status"],
            "periodicidad": widget.loanData!["periodicidad"],
            "customMessage": widget.loanData!["customMessage"],
            "notes": widget.loanData!["notes"],
            "createdAt": widget.loanData!["createdAt"],
          },
      );
    }
    Navigator.pop(context, true); // Volver y refrescar la lista
  }
}


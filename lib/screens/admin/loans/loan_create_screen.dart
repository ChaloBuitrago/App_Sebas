import 'package:flutter/material.dart';
import '../../../services/loan_service.dart';
import '../../../services/user_service.dart';

class LoanCreateScreen extends StatefulWidget {
  const LoanCreateScreen({super.key});

  @override
  _LoanCreateScreenState createState() => _LoanCreateScreenState();
}

class _LoanCreateScreenState extends State<LoanCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  int? selectedUserId;
  final amountController = TextEditingController();
  final interestController = TextEditingController();
  final dateController = TextEditingController();
  String periodicity = "Mensual";

  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  /// 🔹 Cargar usuarios para el dropdown
  Future<void> cargarUsuarios() async {
    final result = await UserService().getAllUsers(); // 🔥 CORREGIDO
    setState(() {
      users = result;
    });
  }

  /// 🔹 Guardar préstamo
  Future<void> guardarPrestamo() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione un usuario")),
      );
      return;
    }

    final newLoan = {
      "userId": selectedUserId,
      "amount": double.parse(amountController.text),
      "interestRate": double.parse(interestController.text),
      "startDate": dateController.text,
      "periodicity": periodicity
    };

    await LoanService().createLoan(newLoan);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Préstamo creado correctamente")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Préstamo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Usuario", style: TextStyle(fontSize: 16)),

              DropdownButtonFormField<int>(
                value: selectedUserId,
                items: users.map((u) {
                  return DropdownMenuItem<int>( // 🔥 CORREGIDO
                    value: u["id"],
                    child: Text("${u["nombre"]} - ${u["identifier"]}"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserId = value;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) =>
                value == null ? "Seleccione un usuario" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Monto del Préstamo",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Ingrese un monto" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: interestController,
                decoration: const InputDecoration(
                  labelText: "Tasa de Interés (%)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? "Ingrese una tasa" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Fecha Inicio (AAAA-MM-DD)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) =>
                value!.isEmpty ? "Ingrese una fecha" : null,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: periodicity,
                items: const [
                  DropdownMenuItem(value: "Diario", child: Text("Diario")),
                  DropdownMenuItem(value: "Semanal", child: Text("Semanal")),
                  DropdownMenuItem(value: "Mensual", child: Text("Mensual")),
                ],
                onChanged: (value) => setState(() => periodicity = value!),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: guardarPrestamo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  "Guardar Préstamo",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

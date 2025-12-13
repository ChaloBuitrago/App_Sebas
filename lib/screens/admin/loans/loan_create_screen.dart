import 'package:flutter/material.dart';
import '../../../services/loan_service.dart';
import '../../../services/user_service.dart';
import 'loan_notification_service.dart'; // ✅ Import correcto

class LoanCreateScreen extends StatefulWidget {
  const LoanCreateScreen({super.key});

  @override
  _LoanCreateScreenState createState() => _LoanCreateScreenState();
}

class _LoanCreateScreenState extends State<LoanCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  int? selectedUserId;

  // ✅ Controladores
  final amountController = TextEditingController();
  final interestController = TextEditingController();
  final dateController = TextEditingController();
  final customMessageController = TextEditingController(); // nuevo campo

  String periodicity = "Mensual";
  List<Map<String, dynamic>> users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  @override
  void dispose() {
    amountController.dispose();
    interestController.dispose();
    dateController.dispose();
    customMessageController.dispose(); // liberar memoria
    super.dispose();
  }

  Future<void> cargarUsuarios() async {
    final result = await UserService().getAllUsers();
    setState(() {
      users = result;
    });
  }

  String calcularFechaCuota(String fechaInicio, String periodicity) {
    final inicio = DateTime.parse(fechaInicio);
    switch (periodicity) {
      case "Diario":
        return inicio.add(const Duration(days: 1)).toIso8601String().split("T").first;
      case "Semanal":
        return inicio.add(const Duration(days: 7)).toIso8601String().split("T").first;
      case "Mensual":
        return DateTime(inicio.year, inicio.month + 1, inicio.day)
            .toIso8601String()
            .split("T")
            .first;
      default:
        return inicio.toIso8601String().split("T").first;
    }
  }

  Future<void> guardarPrestamo() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione un usuario")),
      );
      return;
    }

    final amount = double.tryParse(amountController.text);
    final interest = double.tryParse(interestController.text);

    if (amount == null || interest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Monto o tasa inválidos")),
      );
      return;
    }

    final fechaInicio = dateController.text;
    final dueDate = calcularFechaCuota(fechaInicio, periodicity);

    final newLoan = {
      "userId": selectedUserId,
      "amount": amount,
      "interestRate": interest,
      "startDate": fechaInicio,
      "dueDate": dueDate,
      "status": "pendiente",
      "periodicity": periodicity,
      "customMessage": customMessageController.text.isNotEmpty
          ? customMessageController.text
          : null,
      "createdAt": DateTime.now().toIso8601String(),
    };

    setState(() => _isLoading = true);
    final loanId = await LoanService().createLoan(newLoan);
    setState(() => _isLoading = false);

    // 🔔 Programar notificaciones usando LoanNotificationService
    await LoanNotificationService().scheduleReminderNotifications(
      loanId,
      newLoan["dueDate"],
      newLoan["customMessage"],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Préstamo creado correctamente")),
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
                initialValue: selectedUserId, // ✅ corregido
                items: users.map((u) {
                  return DropdownMenuItem<int>(
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
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null ? "Seleccione un usuario" : null,
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
                validator: (value) => value!.isEmpty ? "Ingrese un monto" : null,
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
                validator: (value) => value!.isEmpty ? "Ingrese una tasa" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Fecha Inicio",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateController.text =
                          pickedDate.toIso8601String().split("T").first;
                    });
                  }
                },
                validator: (value) => value!.isEmpty ? "Ingrese una fecha" : null,
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

              const SizedBox(height: 20),

              TextFormField(
                controller: customMessageController,
                decoration: const InputDecoration(
                  labelText: "Mensaje personalizado (opcional)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : guardarPrestamo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/database_helper.dart';
import 'package:workmanager/workmanager.dart';
import '../../../models/loan_model.dart';
import '../../../services/loan_service.dart';

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({super.key});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _users = [];
  int? _selectedUserId;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaInicioController = TextEditingController();
  final TextEditingController _periodicidadController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('usuarios');
    setState(() => _users = result);
  }

  void _submitLoan() async {
    if (_formKey.currentState!.validate() && _selectedUserId != null) {
      final db = await DatabaseHelper.instance.database;

      await db.insert('loans', {
        'userId': _selectedUserId,
        'amount': _amountController.text,
        'interest': _interestController.text,
        'startDate': _selectedDate!.toIso8601String(),
        'notes': _notesController.text,
        'createdAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💰 Préstamo registrado')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Préstamo'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Seleccionar usuario",
                  border: OutlineInputBorder(),
                ),
                value: _selectedUserId,
                items: _users.map((user) {
                  final int id = user['id'] as int;
                  final String nombre = user['nombre'] ?? 'Sin nombre';
                  final String identifier = user['identifier'] ?? 'Sin ID';

                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text("$nombre - $identifier"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedUserId = value);
                },
                validator: (value) =>
                value == null ? 'Selecciona un usuario' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Monto del préstamo',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Ingresa el monto' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  labelText: 'Tasa de interés (%)',
                  prefixIcon: Icon(Icons.percent),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Ingresa la tasa de interés' : null,
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selectedDate == null
                          ? 'Fecha del préstamo'
                          : "Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (_) =>
                    _selectedDate == null ? 'Selecciona una fecha' : null,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas u observaciones',
                  prefixIcon: Icon(Icons.note_alt),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  // 1. Crear el modelo con los datos del formulario
                  final loan = LoanModel(
                    userId: int.parse(_userIdController.text),
                    monto: double.parse(_montoController.text),
                    fechaInicio: _fechaInicioController.text,
                    periodicidad: _periodicidadController.text,
                    tasa: double.parse(_tasaController.text),
                    mensajeRecordatorio: _mensajeController.text, // nuevo campo
                  );

                  // 2. Guardar en base de datos (ejemplo con tu LoanService)
                  await LoanService().createLoan(loan.toMap());

                  // 3. Calcular próxima fecha de recordatorio
                  final fechaRecordatorio = loan.calcularProximaFecha();

                  // 4. Programar SMS con WorkManager
                  Workmanager().registerOneOffTask(
                    "recordatorio_${loan.id ?? DateTime.now().millisecondsSinceEpoch}",
                    "enviarSms",
                    inputData: {
                      "telefono": _telefonoController.text,
                      "mensaje": loan.mensajeRecordatorio ?? "Recordatorio de tu préstamo",
                    },
                    initialDelay: fechaRecordatorio.difference(DateTime.now()),
                  );

                  // 5. Feedback al admin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Préstamo guardado y recordatorio programado")),
                  );
                },
                child: const Text("Guardar préstamo"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


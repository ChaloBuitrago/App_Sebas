import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/database_helper.dart';

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
                onPressed: _submitLoan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar Préstamo',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


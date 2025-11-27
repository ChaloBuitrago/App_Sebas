import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import 'loan_detail_screen.dart';

class LoansListScreen extends StatefulWidget {
  const LoansListScreen({super.key});

  @override
  State<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends State<LoansListScreen> {
  List<Map<String, dynamic>> _loans = [];

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery('''
      SELECT loans.id, loans.amount, loans.interest, loans.startDate,
             usuarios.nombre AS userName, usuarios.identifier
      FROM loans
      INNER JOIN usuarios ON usuarios.id = loans.userId
      ORDER BY loans.startDate DESC
    ''');

    setState(() => _loans = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préstamos Registrados"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _loans.isEmpty
          ? const Center(child: Text("No hay préstamos registrados"))
          : ListView.builder(
        itemCount: _loans.length,
        itemBuilder: (_, i) {
          final loan = _loans[i];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                loan["userName"] ?? "Usuario desconocido",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${loan['identifier']}"),
                  Text("Monto: \$${loan['amount']}"),
                  Text("Interés: ${loan['interest']}%"),
                  Text("Fecha: ${loan['startDate'].toString().substring(0, 10)}"),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoanDetailScreen(loanId: loan['id']),
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

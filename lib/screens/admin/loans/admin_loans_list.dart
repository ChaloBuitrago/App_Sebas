import 'package:flutter/material.dart';
import '../../../services/loan_service.dart';
import 'loan_detail_screen.dart';

class AdminLoansList extends StatefulWidget {
  const AdminLoansList({Key? key}) : super(key: key);

  @override
  State<AdminLoansList> createState() => _AdminLoansListState();
}

class _AdminLoansListState extends State<AdminLoansList> {
  List<Map<String, dynamic>> loans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPrestamos();
  }

  /// 🔹 Cargar préstamos desde LoanService
  Future<void> cargarPrestamos() async {
    final result = await LoanService().getAllLoans(); // asegúrate de tener este método en LoanService
    setState(() {
      loans = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préstamos Activos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : loans.isEmpty
          ? const Center(child: Text("No hay préstamos registrados"))
          : ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.green),
              title: Text("Usuario ID: ${loan['userId']}"),
              subtitle: Text("Monto: \$${loan['amount']} - Fecha: ${loan['startDate']}"),
              trailing: Text(loan['status'] ?? "Pendiente"),
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


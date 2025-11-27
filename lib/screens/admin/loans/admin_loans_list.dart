import 'package:flutter/material.dart';
import 'loan_detail_screen.dart';

class AdminLoansList extends StatelessWidget {
  const AdminLoansList({Key? key}) : super(key: key);

  // Simulación temporal
  final List<Map<String, dynamic>> loans = const [
    {"id": 1, "user": "Juan Pérez", "amount": 500000, "status": "Pendiente"},
    {"id": 2, "user": "María López", "amount": 300000, "status": "Pagado"},
    {"id": 3, "user": "Carlos Ruiz", "amount": 150000, "status": "Pendiente"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Préstamos Activos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];

          return ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text("${loan['user']}"),
            subtitle: Text("Monto: \$${loan['amount']}"),
            trailing: Text(loan['status']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoanDetailScreen(loanId: loan['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


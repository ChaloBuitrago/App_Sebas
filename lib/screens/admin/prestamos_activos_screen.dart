import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import 'loans/loan_form_screen.dart';

class PrestamosActivosScreen extends StatefulWidget {
  const PrestamosActivosScreen({super.key});

  @override
  State<PrestamosActivosScreen> createState() => _PrestamosActivosScreenState();
}

class _PrestamosActivosScreenState extends State<PrestamosActivosScreen> {
  List<Map<String, dynamic>> loans = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLoans();
  }

  Future<void> loadLoans() async {
    setState(() => loading = true);

    final data = await DatabaseHelper.instance.getAllLoans();

    setState(() {
      loans = data;
      loading = false;
    });
  }

  Future<void> deleteLoan(int id) async {
    await DatabaseHelper.instance.deleteLoan(id);
    loadLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamos Activos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loans.isEmpty
          ? const Center(
        child: Text(
          "No hay préstamos registrados",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final l = loans[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                "ID: ${l['id']} - Usuario: ${l['userName']}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                "Monto: \$${l['amount']} | Interés: ${l['interest']}%\n"
                    "Fecha: ${l['startDate']}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✏️ Editar préstamo
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LoanFormScreen(loanData: l),
                        ),
                      ).then((_) => loadLoans());
                    },
                  ),

                  // 🗑️ Eliminar préstamo
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteLoan(l["id"]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



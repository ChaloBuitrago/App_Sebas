import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../loans/loan_form_screen.dart';

class UserLoansScreen extends StatefulWidget {
  final int userId;

  UserLoansScreen({required this.userId});

  @override
  _UserLoansScreenState createState() => _UserLoansScreenState();
}

class _UserLoansScreenState extends State<UserLoansScreen> {
  List<Map<String, dynamic>> loans = [];

  @override
  void initState() {
    super.initState();
    loadLoans();
  }

  Future<void> loadLoans() async {
    loans = await DatabaseHelper.instance.getLoansByUser(widget.userId);
    setState(() {});
  }

  Future<void> deleteLoan(int id) async {
    await DatabaseHelper.instance.deleteLoan(id);
    loadLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Préstamos del Usuario")),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, i) {
          final l = loans[i];

          return Card(
            child: ListTile(
              title: Text("Monto: \$${l["amount"]}"),
              subtitle: Text("Interés: ${l["interest"]}%\nFecha: ${l["startDate"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoanFormScreen(loanData: l),
                        ),
                      ).then((_) => loadLoans());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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

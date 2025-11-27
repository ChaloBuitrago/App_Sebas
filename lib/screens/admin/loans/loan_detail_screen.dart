import 'package:flutter/material.dart';

class LoanDetailScreen extends StatefulWidget {
  final int loanId;

  const LoanDetailScreen({Key? key, required this.loanId}) : super(key: key);

  @override
  _LoanDetailScreenState createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  Map<String, dynamic>? _loanData;
  bool _isLoading = true;

  // Simulación temporal
  Future<Map<String, dynamic>> _fetchLoan(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "id": id,
      "user": "Juan Pérez",
      "amount": 500000,
      "date": "2024-01-15",
      "status": "Pendiente",
      "description": "Préstamo para compra de materiales"
    };
  }

  @override
  void initState() {
    super.initState();
    _loadLoan();
  }

  Future<void> _loadLoan() async {
    final data = await _fetchLoan(widget.loanId);
    setState(() {
      _loanData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del préstamo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usuario: ${_loanData!['user']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Monto: \$${_loanData!['amount']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Fecha: ${_loanData!['date']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Estado: ${_loanData!['status']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text("Descripción:",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_loanData!['description'],
                style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Marcar como pagado"),
            ),
          ],
        ),
      ),
    );
  }
}

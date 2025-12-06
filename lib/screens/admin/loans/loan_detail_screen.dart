import 'package:flutter/material.dart';
import '../../../services/loan_service.dart';

class LoanDetailScreen extends StatefulWidget {
  final int loanId;

  const LoanDetailScreen({Key? key, required this.loanId}) : super(key: key);

  @override
  _LoanDetailScreenState createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  Map<String, dynamic>? _loanData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoan();
  }

  /// 🔹 Cargar préstamo desde LoanService
  Future<void> _loadLoan() async {
    final data = await LoanService().getLoanById(widget.loanId);
    setState(() {
      _loanData = data;
      _isLoading = false;
    });
  }

  /// 🔹 Marcar préstamo como pagado
  Future<void> _markAsPaid() async {
    if (_loanData == null) return;

    final updatedLoan = Map<String, dynamic>.from(_loanData!);
    updatedLoan['status'] = 'Pagado';

    await LoanService().updateLoan(widget.loanId, updatedLoan);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Préstamo marcado como pagado")),
    );

    _loadLoan(); // recargar datos actualizados
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
          : _loanData == null
          ? const Center(child: Text("Préstamo no encontrado"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Usuario ID: ${_loanData!['userId']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Monto: \$${_loanData!['amount']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Tasa de interés: ${_loanData!['interestRate']}%",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Fecha inicio: ${_loanData!['startDate']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Periodicidad: ${_loanData!['periodicity']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Estado: ${_loanData!['status'] ?? 'Pendiente'}",
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              onPressed: _loanData!['status'] == 'Pagado'
                  ? null
                  : _markAsPaid,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Marcar como pagado"),
            ),
          ],
        ),
      ),
    );
  }
}
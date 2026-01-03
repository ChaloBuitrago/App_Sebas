import '../../../services/database_helper.dart';
import 'package:flutter/material.dart';
import 'loan_form_screen.dart';

class PagosPendientesScreen extends StatefulWidget {
  const PagosPendientesScreen({Key? key}) : super(key: key);

  @override
  State<PagosPendientesScreen> createState() => _PagosPendientesScreenState();
}

class _PagosPendientesScreenState extends State<PagosPendientesScreen> {
  List<Map<String, dynamic>> pagos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPagosPendientes();
  }
  Future<void> loadPagosPendientes() async {
    setState(() => loading = true);
    try {
      final data = await DatabaseHelper.instance.getPendingPayments();
      setState(() {
        pagos = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        pagos = [];
        loading = false;
      });
      debugPrint("Error al cargar pagos pendientes: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagos Pendientes'),
          backgroundColor: Colors.orange,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : pagos.isEmpty
            ? const Center(child: Text("No hay pagos pendientes"))
            : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pagos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = pagos[index];
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      "Usuario ID: ${item["userId"]}", // usar userId en lugar de userName
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Fecha inicio: ${item["StartDate"]}"),
                    trailing: Text(
                      "\$${item["amount"]}", // se usa amount para mostrar el monto
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoanFormScreen(loanData: item),
                        ),
                      ).then((_) => loadPagosPendientes());
                    },
                  ),
              );
            },
        ),
    );
  }
}


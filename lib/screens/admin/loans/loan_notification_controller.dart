import '../../../services/database_helper.dart';
import '../../../services/notifications_service.dart';

class LoanNotificationController {
  static Future<void> checkAndScheduleNotifications() async {
    final loans = await DatabaseHelper.instance.getLoansForNotifications();

    for (var loan in loans) {
      final periodicidad = loan['periodicidad'];
      final mensaje = loan['customMessage'] ?? "Recuerde su pago de préstamo";
      final startDate = DateTime.parse(loan['startDate']);
      final dueDate = loan['dueDate'] != null ? DateTime.parse(loan['dueDate']) : null;

      // Definir fecha de notificación según periodicidad
      DateTime scheduledDate = DateTime.now();

      switch (periodicidad) {
        case 'Diario':
          scheduledDate = DateTime.now().add(const Duration(days: 1));
          break;
        case 'Semanal':
          scheduledDate = DateTime.now().add(const Duration(days: 7));
          break;
        case 'Mensual':
          scheduledDate = DateTime.now().add(const Duration(days: 30));
          break;
      }

      // Si hay fecha de vencimiento próxima (< 2 días), notificar antes
      if (dueDate != null && dueDate.difference(DateTime.now()).inDays <= 2) {
        scheduledDate = DateTime.now().add(const Duration(hours: 1));
      }

      await NotificationService().scheduleNotification(
        loan['id'],
        "Recordatorio de préstamo",
        "$mensaje - Monto: \$${loan['amount']} - Interés: ${loan['interest'] * 100}%",
        scheduledDate,
      );
    }
  }
}
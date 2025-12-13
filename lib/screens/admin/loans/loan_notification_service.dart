import '../../../services/notifications_service.dart';

const bool demoMode = true; // ✅ activar el demo para la muestra rápida

Duration getDuration({int days = 0, int hours = 0, int minutes = 0}) {
  if (demoMode) {
    return Duration(minutes: minutes > 0 ? minutes : 1);
  } else {
    return Duration(days: days, hours: hours);
  }
}

class LoanNotificationService {
  /// 🔹 Recordatorios antes del vencimiento
  Future<void> scheduleReminderNotifications(
      int loanId, Object? dueDate, Object? customMessage) async {
    final fecha = dueDate?.toString() ?? "";
    final mensaje = (customMessage?.toString().isNotEmpty ?? false)
        ? customMessage.toString()
        : "Tu préstamo vence el $fecha";

    // 3 días antes
    await NotificationService().scheduleNotification(
      loanId * 10 + 1,
      "Recordatorio de pago",
      mensaje,
      DateTime.parse(fecha).subtract(const Duration(days: 3)),
    );

    // 1 día antes
    await NotificationService().scheduleNotification(
      loanId * 10 + 2,
      "Recordatorio de pago",
      mensaje,
      DateTime.parse(fecha).subtract(const Duration(days: 1)),
    );

    // El mismo día
    await NotificationService().scheduleNotification(
      loanId * 10 + 3,
      "Pago de préstamo",
      mensaje,
      DateTime.parse(fecha),
    );
  }

  /// 🔹 Notificaciones de mora (ejemplo: 5 días, 2 recordatorios diarios)
  Future<void> scheduleLateNotifications(
      int loanId, String? customMessage) async {
    final mensaje = (customMessage != null && customMessage.isNotEmpty)
        ? customMessage
        : "Tu préstamo está en mora. Realiza el pago lo antes posible.";

    for (int i = 0; i < 5; i++) {
      final morning = DateTime.now().add(Duration(days: i, hours: 9));
      final evening = DateTime.now().add(Duration(days: i, hours: 18));

      await NotificationService().scheduleNotification(
        loanId * 100 + i * 2,
        "Pago atrasado",
        mensaje,
        morning,
      );

      await NotificationService().scheduleNotification(
        loanId * 100 + i * 2 + 1,
        "Pago atrasado",
        mensaje,
        evening,
      );
    }
  }
}
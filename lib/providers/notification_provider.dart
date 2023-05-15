import 'package:moqefapp/database/database.dart';
import 'package:moqefapp/database/db_handler.dart';
import 'package:moqefapp/models/notification.dart';
import 'package:moqefapp/providers/base_provider.dart';

class NotificationProvider extends BaseProvider {
  List<Notif> _notifications = List.empty(growable: true);
  List<Notif> get notifications => _notifications;

  final DatabaseHandler _db = DatabaseHandler();

  Future<void> addNotification(Notif notification) async {
    var result = await _db.addNotification(notification);
    if (result) {
      _notifications.add(notification);
      notifyListeners();
    }
  }

  Future<List<Notif>> getNotifications() async {
    List<Notif>? notifications = await _db.getNotifications();
    if (notifications != null) {
      _notifications = notifications;
      notifyListeners();
    }
    return notifications!;
  }

  Future<List<Notif>> notificationsApp() async {
    List<Notif> notifis = [];
    await Database.instance.notificationCollection.get().then((doc) async {
      for (var doc in doc.docs) {
        final notif = Notif.fromMap(doc.data() as Map<String, dynamic>);
        notifis.add(notif);
      }
    });
    notifyListeners();
    return notifis;
  }

  void clearNotifications() {
    if (_notifications.isNotEmpty) {
      _db.clearNotifications();
      _notifications.clear();
      notifyListeners();
    }
  }
}

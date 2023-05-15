// ignore_for_file: depend_on_referenced_packages

import 'package:moqefapp/models/notification.dart';

import "package:path/path.dart" show join;
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<bool> addNotification(Notif notification) async {
    Database database = await initializeDB();
    if (database.isOpen) {
      int i = await database.insert('notification', notification.toMap());
      if (i > 0) return true;
    }
    return false;
  }

  clearNotifications() async {
    Database database = await initializeDB();
    if (database.isOpen) {
      int i = await database.delete('notification');
      if (i > 0) return true;
    }
    return false;
  }

  Future<List<Notif>?> getNotifications() async {
    Database database = await initializeDB();
    if (database.isOpen) {
      List<Map<String, Object?>> data = await database.query('notification');
      List<Notif> notifications = List.empty(growable: true);
      for (var element in data) {
        notifications.add(Notif.fromMap(element));
      }
      return notifications;
    }
    return null;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    databaseExists(path);
    return openDatabase(
      join(path, 'notification.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE notification(id INTEGER,title TEXT ,body TEXT)",
        );
        await database
            .execute("CREATE TABLE instagram(imageUrl TEXT,postUrl  TEXT)");
      },
      version: 1,
    );
  }
}

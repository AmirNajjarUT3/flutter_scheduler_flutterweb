import 'package:appointment_scheduler_flutterweb/database/db.dart';

class DBHelper {
  static AppDb getDbInstance() {
    return AppDb();
  }

  static Future<List<Availability>> getAvailabilities(
    AppDb db,
  ) async {
    return await db.getAvailabilities();
  }

  static Future<int> addAvailability(
    AppDb db,
    DateTime startTime,
    DateTime endTime,
  ) async {
    return await db.addAvailability(startTime, endTime);
  }

  static Future<void> addAvailabilities(
    AppDb db,
    List<Availability> availabilities,
  ) async {
    await db.addBatchAvailabilities(availabilities);
  }

  static Future<int> deleteAvailability(
    AppDb db,
    int id,
  ) async {
    return await db.deleteAvailability(id);
  }

  static Future<int> clearAvailabilites(
    AppDb db,
  ) async {
    return await db.clearAvailabilites();
  }

  static Future<int> createReservation(
    AppDb db,
    String id,
    DateTime startTime,
    DateTime endTime,
    String title,
    String email,
  ) async {
    return await db.createReservation(id, startTime, endTime, title, email);
  }

  static Future<List<String>> getAllReservationIds(
    AppDb db,
  ) async {
    List<String> result = await db.getAllReservationIds();
    return result;
  }

  static Future<Reservation?> getReservation(
      AppDb db, String ref, String email) async {
    return db.getReservation(
      ref,
      email,
    );
  }

  static Future<int> deleteReservation(
    AppDb db,
    String id,
    String email,
  ) async {
    return await db.deleteReservation(id, email);
  }

  static Future<int> clearReservations(
    AppDb db,
  ) async {
    return await db.clearReservations();
  }
}

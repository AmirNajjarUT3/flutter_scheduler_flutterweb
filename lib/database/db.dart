import 'package:drift/drift.dart';
import 'package:drift/web.dart';
part 'db.g.dart';

@DriftDatabase(
  include: {'tables.drift'},
)
class AppDb extends _$AppDb {
  AppDb() : super(WebDatabase('db'));

  @override
  int get schemaVersion => 1;

  Future<List<Availability>> getAvailabilities() async =>
      await select(availabilites).get();

  Future<int> addAvailability(DateTime startTime, DateTime endTime) async {
    AvailabilitesCompanion entry = AvailabilitesCompanion(
      starttime: Value(startTime),
      endtime: Value(endTime),
    );
    return await into(availabilites).insert(entry);
  }

  Future<void> addBatchAvailabilities(List<Availability> times) async {
    await batch((batch) {
      batch.insertAll(
        availabilites,
        times
            .map((availability) => AvailabilitesCompanion.insert(
                  starttime: availability.starttime,
                  endtime: availability.endtime,
                ))
            .toList(),
      );
    });
  }

  Future<int> deleteAvailability(int id) async {
    return await (delete(availabilites)..where((tbl) => (tbl.id.equals(id))))
        .go();
  }

  Future<int> clearAvailabilites() async {
    return await (delete(availabilites)).go();
  }

  Future<int> createReservation(String id, DateTime startTime, DateTime endTime,
      String title, String email) async {
    ReservationsCompanion entry = ReservationsCompanion(
      id: Value(id),
      starttime: Value(startTime),
      endtime: Value(endTime),
      title: Value(title),
      email: Value(email),
    );
    return await into(reservations).insert(entry);
  }

  Future<Reservation?> getReservation(String ref, String email) async {
    List<Reservation> ls = await select(reservations).get();
    if (ls
        .where((element) =>
            (element.id.compareTo(ref) == 0) &
            (element.email.compareTo(email) == 0))
        .isEmpty) {
      return null;
    }
    return ls
        .where((element) =>
            (element.id.compareTo(ref) == 0) &
            (element.email.compareTo(email) == 0))
        .first;
  }

  Future<List<String>> getAllReservationIds() async {
    List<Reservation> result = await select(reservations).get();
    return result.map((reservation) => reservation.id).toList();
  }

  Future<int> deleteReservation(String id, String email) async {
    return await (delete(reservations)
          ..where(((tbl) => (tbl.id.equals(id) & tbl.email.equals(email)))))
        .go();
  }

  Future<int> clearReservations() async {
    return await (delete(reservations)).go();
  }
}

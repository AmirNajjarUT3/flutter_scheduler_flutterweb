import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:tuple/tuple.dart';

part 'db.g.dart';

@DriftDatabase(
  include: {'tables.drift'},
)
class AppDb extends _$AppDb {
  AppDb() : super(WebDatabase('db'));

  @override
  int get schemaVersion => 1;

  Future<List<Availability>> getAvailabilities() => select(availabilites).get();

  Future<int> addAvailability(DateTime startTime, DateTime endTime) async {
    AvailabilitesCompanion entry = AvailabilitesCompanion(
      starttime: Value(startTime),
      endtime: Value(endTime),
    );
    return await into(availabilites).insert(entry);
  }

  Future<void> addBatchAvailabilities(
      List<Tuple2<DateTime, DateTime>> times) async {
    await batch((batch) {
      batch.insertAll(
        availabilites,
        times
            .map((value) => AvailabilitesCompanion.insert(
                  starttime: value.item1,
                  endtime: value.item2,
                ))
            .toList(),
      );
    });
  }

  Future<int> deleteAvailability(DateTime startTime, DateTime endTime) async {
    return await (delete(availabilites)
          ..where((tbl) =>
              (tbl.starttime.equals(startTime) & tbl.endtime.equals(endTime))))
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

  Future<int> deleteReservation(String id, String email) {
    return (delete(reservations)
          ..where(((tbl) => (tbl.id.equals(id) & tbl.email.equals(email)))))
        .go();
  }

  Future<int> clearReservations() {
    return (delete(reservations)).go();
  }
}

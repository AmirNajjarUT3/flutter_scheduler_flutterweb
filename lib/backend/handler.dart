import 'package:appointment_scheduler_flutterweb/backend/db_helper.dart';
import 'package:appointment_scheduler_flutterweb/database/db.dart';
import 'package:appointment_scheduler_flutterweb/backend/constants.dart'
    as constants;
import 'package:flutter/foundation.dart';
import 'dart:math';

class Handler with ChangeNotifier {
  List<Availability> _availabilities = [];
  final AppDb _dbInstance = DBHelper.getDbInstance();
  Future<void> fetchAvailabilities() async {
    _availabilities = await DBHelper.getAvailabilities(_dbInstance);
    if (_availabilities.isEmpty) {
      for (DateTime curDT = DateTime.now().compareTo(constants.START_DATE) > 0
              ? DateTime.now()
              : constants.START_DATE;
          curDT.compareTo(constants.END_DATE) <= 0;
          curDT = curDT.add(Duration(days: 1))) {
        if (curDT.weekday > 5) continue;
        // Create the availabilities needed in the database
        _availabilities.add(
          Availability(
            id: -1,
            starttime: DateTime(curDT.year, curDT.month, curDT.day, 8, 0),
            endtime: DateTime(curDT.year, curDT.month, curDT.day, 12, 0),
          ),
        );
        _availabilities.add(
          Availability(
            id: -1,
            starttime: DateTime(curDT.year, curDT.month, curDT.day, 13, 0),
            endtime: DateTime(curDT.year, curDT.month, curDT.day, 18, 0),
          ),
        );
      }
      await DBHelper.addAvailabilities(_dbInstance, _availabilities);
      _availabilities = await DBHelper.getAvailabilities(_dbInstance);
      _availabilities.sort((a, b) => a.starttime.compareTo(b.starttime));
    }
    notifyListeners();
  }

  Map<DateTime, List<DateTime>> get dayMap {
    Map<DateTime, List<DateTime>> result = {};
    for (DateTime dt = constants.START_DATE;
        dt.compareTo(constants.END_DATE) <= 0;
        dt = dt.add(Duration(days: 1))) {
      if (dt.weekday > 5) continue;
      result[dt] = _possibleTimes(dt);
      result[dt]!.sort((a, b) => a.compareTo(b));
    }
    return result;
  }

  bool isSameHalf(DateTime dt1, DateTime dt2) {
    return ((dt1.hour <= 12) & (dt2.hour <= 12)) |
        ((dt1.hour >= 13) & (dt2.hour >= 13));
  }

  List<DateTime> getTimesGivenStart(DateTime startTime) {
    List<DateTime> result = [];
    final pTimes = _possibleTimesLEQ(startTime);
    for (var time in pTimes) {
      if (isSameHalf(startTime, time) &
          (time.difference(startTime).inMinutes <=
              Duration(minutes: 60).inMinutes) &
          (time.compareTo(startTime) > 0)) {
        result.add(time);
      }
    }
    return result;
  }

  List<DateTime> _possibleTimes(DateTime day) {
    List<DateTime> result = [];
    for (Availability av in _availabilities) {
      if (av.starttime.difference(day).inDays == 0) {
        for (DateTime ctime = av.starttime;
            ctime.compareTo(av.endtime) < 0;
            ctime = ctime.add(Duration(minutes: 5))) {
          result.add(ctime);
        }
      }
    }
    return result;
  }

  List<DateTime> _possibleTimesLEQ(DateTime day) {
    List<DateTime> result = [];
    for (Availability av in _availabilities) {
      if (av.starttime.difference(day).inDays == 0) {
        for (DateTime ctime = av.starttime;
            ctime.compareTo(av.endtime) <= 0;
            ctime = ctime.add(Duration(minutes: 5))) {
          result.add(ctime);
        }
      }
    }
    return result;
  }

  Future<void> addAvailability(
    DateTime startTime,
    DateTime endTime,
  ) async {
    int id = await DBHelper.addAvailability(_dbInstance, startTime, endTime);
    Availability av = Availability(
      id: id,
      starttime: startTime,
      endtime: endTime,
    );
    _availabilities.add(av);
    notifyListeners();
  }

  Future<void> deleteAvailability(
    int id,
  ) async {
    _availabilities.removeWhere((availability) => (availability.id == id));
    notifyListeners();
    await DBHelper.deleteAvailability(_dbInstance, id);
  }

  Future<void> clearAvailabilities() async {
    await DBHelper.clearAvailabilites(_dbInstance);
    await fetchAvailabilities();
    notifyListeners();
  }

  Future<String> createReservation(
    DateTime startTime,
    DateTime endTime,
    String title,
    String email,
  ) async {
    for (Availability av in _availabilities) {
      if ((av.starttime.compareTo(startTime) <= 0) &
          (av.endtime.compareTo(endTime) >= 0)) {
        // delete current availability
        await deleteAvailability(av.id);
        // create before startTime and handle an empty availability
        if (!av.starttime.isAtSameMomentAs(startTime)) {
          await addAvailability(av.starttime, startTime);
        }
        // create after endTime
        if (!av.endtime.isAtSameMomentAs(endTime)) {
          await addAvailability(endTime, av.endtime);
        }
        await fetchAvailabilities();
        // create the reservation
        Random rnd = Random();
        String id = '';
        bool dupId = true;
        List<String> allReservationIds = await DBHelper.getAllReservationIds(
          _dbInstance,
        );
        while (dupId) {
          id = String.fromCharCodes(
            List.generate(5, (index) => rnd.nextInt(26) + 65),
          );
          dupId = allReservationIds.contains(id);
        }
        await DBHelper.createReservation(
          _dbInstance,
          id,
          startTime,
          endTime,
          title,
          email,
        );
        return id;
      }
    }
    return "Couldn't get a reservation";
  }

  Future<bool> deleteReservation(String id, String email) async {
    Reservation? res = await DBHelper.getReservation(_dbInstance, id, email);
    if (res == null) {
      return false;
    }
    await DBHelper.deleteReservation(
      _dbInstance,
      id,
      email,
    );
    await DBHelper.addAvailability(
      _dbInstance,
      res.starttime,
      res.endtime,
    );
    await fetchAvailabilities();
    return true;
  }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value)) return false;
    return true;
  }
}

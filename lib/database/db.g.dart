// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Availability extends DataClass implements Insertable<Availability> {
  final int id;
  final DateTime starttime;
  final DateTime endtime;
  const Availability(
      {required this.id, required this.starttime, required this.endtime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['starttime'] = Variable<DateTime>(starttime);
    map['endtime'] = Variable<DateTime>(endtime);
    return map;
  }

  AvailabilitesCompanion toCompanion(bool nullToAbsent) {
    return AvailabilitesCompanion(
      id: Value(id),
      starttime: Value(starttime),
      endtime: Value(endtime),
    );
  }

  factory Availability.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Availability(
      id: serializer.fromJson<int>(json['id']),
      starttime: serializer.fromJson<DateTime>(json['starttime']),
      endtime: serializer.fromJson<DateTime>(json['endtime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'starttime': serializer.toJson<DateTime>(starttime),
      'endtime': serializer.toJson<DateTime>(endtime),
    };
  }

  Availability copyWith({int? id, DateTime? starttime, DateTime? endtime}) =>
      Availability(
        id: id ?? this.id,
        starttime: starttime ?? this.starttime,
        endtime: endtime ?? this.endtime,
      );
  @override
  String toString() {
    return (StringBuffer('Availability(')
          ..write('id: $id, ')
          ..write('starttime: $starttime, ')
          ..write('endtime: $endtime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, starttime, endtime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Availability &&
          other.id == this.id &&
          other.starttime == this.starttime &&
          other.endtime == this.endtime);
}

class AvailabilitesCompanion extends UpdateCompanion<Availability> {
  final Value<int> id;
  final Value<DateTime> starttime;
  final Value<DateTime> endtime;
  const AvailabilitesCompanion({
    this.id = const Value.absent(),
    this.starttime = const Value.absent(),
    this.endtime = const Value.absent(),
  });
  AvailabilitesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime starttime,
    required DateTime endtime,
  })  : starttime = Value(starttime),
        endtime = Value(endtime);
  static Insertable<Availability> custom({
    Expression<int>? id,
    Expression<DateTime>? starttime,
    Expression<DateTime>? endtime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (starttime != null) 'starttime': starttime,
      if (endtime != null) 'endtime': endtime,
    });
  }

  AvailabilitesCompanion copyWith(
      {Value<int>? id, Value<DateTime>? starttime, Value<DateTime>? endtime}) {
    return AvailabilitesCompanion(
      id: id ?? this.id,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (starttime.present) {
      map['starttime'] = Variable<DateTime>(starttime.value);
    }
    if (endtime.present) {
      map['endtime'] = Variable<DateTime>(endtime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilitesCompanion(')
          ..write('id: $id, ')
          ..write('starttime: $starttime, ')
          ..write('endtime: $endtime')
          ..write(')'))
        .toString();
  }
}

class Availabilites extends Table with TableInfo<Availabilites, Availability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Availabilites(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _starttimeMeta = const VerificationMeta('starttime');
  late final GeneratedColumn<DateTime> starttime = GeneratedColumn<DateTime>(
      'starttime', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _endtimeMeta = const VerificationMeta('endtime');
  late final GeneratedColumn<DateTime> endtime = GeneratedColumn<DateTime>(
      'endtime', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, starttime, endtime];
  @override
  String get aliasedName => _alias ?? 'availabilites';
  @override
  String get actualTableName => 'availabilites';
  @override
  VerificationContext validateIntegrity(Insertable<Availability> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('starttime')) {
      context.handle(_starttimeMeta,
          starttime.isAcceptableOrUnknown(data['starttime']!, _starttimeMeta));
    } else if (isInserting) {
      context.missing(_starttimeMeta);
    }
    if (data.containsKey('endtime')) {
      context.handle(_endtimeMeta,
          endtime.isAcceptableOrUnknown(data['endtime']!, _endtimeMeta));
    } else if (isInserting) {
      context.missing(_endtimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Availability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Availability(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      starttime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}starttime'])!,
      endtime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}endtime'])!,
    );
  }

  @override
  Availabilites createAlias(String alias) {
    return Availabilites(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Reservation extends DataClass implements Insertable<Reservation> {
  final String id;
  final DateTime starttime;
  final DateTime endtime;
  final String title;
  final String email;
  const Reservation(
      {required this.id,
      required this.starttime,
      required this.endtime,
      required this.title,
      required this.email});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['starttime'] = Variable<DateTime>(starttime);
    map['endtime'] = Variable<DateTime>(endtime);
    map['title'] = Variable<String>(title);
    map['email'] = Variable<String>(email);
    return map;
  }

  ReservationsCompanion toCompanion(bool nullToAbsent) {
    return ReservationsCompanion(
      id: Value(id),
      starttime: Value(starttime),
      endtime: Value(endtime),
      title: Value(title),
      email: Value(email),
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reservation(
      id: serializer.fromJson<String>(json['id']),
      starttime: serializer.fromJson<DateTime>(json['starttime']),
      endtime: serializer.fromJson<DateTime>(json['endtime']),
      title: serializer.fromJson<String>(json['title']),
      email: serializer.fromJson<String>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'starttime': serializer.toJson<DateTime>(starttime),
      'endtime': serializer.toJson<DateTime>(endtime),
      'title': serializer.toJson<String>(title),
      'email': serializer.toJson<String>(email),
    };
  }

  Reservation copyWith(
          {String? id,
          DateTime? starttime,
          DateTime? endtime,
          String? title,
          String? email}) =>
      Reservation(
        id: id ?? this.id,
        starttime: starttime ?? this.starttime,
        endtime: endtime ?? this.endtime,
        title: title ?? this.title,
        email: email ?? this.email,
      );
  @override
  String toString() {
    return (StringBuffer('Reservation(')
          ..write('id: $id, ')
          ..write('starttime: $starttime, ')
          ..write('endtime: $endtime, ')
          ..write('title: $title, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, starttime, endtime, title, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reservation &&
          other.id == this.id &&
          other.starttime == this.starttime &&
          other.endtime == this.endtime &&
          other.title == this.title &&
          other.email == this.email);
}

class ReservationsCompanion extends UpdateCompanion<Reservation> {
  final Value<String> id;
  final Value<DateTime> starttime;
  final Value<DateTime> endtime;
  final Value<String> title;
  final Value<String> email;
  const ReservationsCompanion({
    this.id = const Value.absent(),
    this.starttime = const Value.absent(),
    this.endtime = const Value.absent(),
    this.title = const Value.absent(),
    this.email = const Value.absent(),
  });
  ReservationsCompanion.insert({
    required String id,
    required DateTime starttime,
    required DateTime endtime,
    required String title,
    required String email,
  })  : id = Value(id),
        starttime = Value(starttime),
        endtime = Value(endtime),
        title = Value(title),
        email = Value(email);
  static Insertable<Reservation> custom({
    Expression<String>? id,
    Expression<DateTime>? starttime,
    Expression<DateTime>? endtime,
    Expression<String>? title,
    Expression<String>? email,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (starttime != null) 'starttime': starttime,
      if (endtime != null) 'endtime': endtime,
      if (title != null) 'title': title,
      if (email != null) 'email': email,
    });
  }

  ReservationsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? starttime,
      Value<DateTime>? endtime,
      Value<String>? title,
      Value<String>? email}) {
    return ReservationsCompanion(
      id: id ?? this.id,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
      title: title ?? this.title,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (starttime.present) {
      map['starttime'] = Variable<DateTime>(starttime.value);
    }
    if (endtime.present) {
      map['endtime'] = Variable<DateTime>(endtime.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationsCompanion(')
          ..write('id: $id, ')
          ..write('starttime: $starttime, ')
          ..write('endtime: $endtime, ')
          ..write('title: $title, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }
}

class Reservations extends Table with TableInfo<Reservations, Reservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Reservations(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  final VerificationMeta _starttimeMeta = const VerificationMeta('starttime');
  late final GeneratedColumn<DateTime> starttime = GeneratedColumn<DateTime>(
      'starttime', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _endtimeMeta = const VerificationMeta('endtime');
  late final GeneratedColumn<DateTime> endtime = GeneratedColumn<DateTime>(
      'endtime', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, starttime, endtime, title, email];
  @override
  String get aliasedName => _alias ?? 'RESERVATIONS';
  @override
  String get actualTableName => 'RESERVATIONS';
  @override
  VerificationContext validateIntegrity(Insertable<Reservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('starttime')) {
      context.handle(_starttimeMeta,
          starttime.isAcceptableOrUnknown(data['starttime']!, _starttimeMeta));
    } else if (isInserting) {
      context.missing(_starttimeMeta);
    }
    if (data.containsKey('endtime')) {
      context.handle(_endtimeMeta,
          endtime.isAcceptableOrUnknown(data['endtime']!, _endtimeMeta));
    } else if (isInserting) {
      context.missing(_endtimeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reservation(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      starttime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}starttime'])!,
      endtime: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}endtime'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      email: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
    );
  }

  @override
  Reservations createAlias(String alias) {
    return Reservations(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final Availabilites availabilites = Availabilites(this);
  late final Reservations reservations = Reservations(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [availabilites, reservations];
}
